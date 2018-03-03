# frozen_string_literal: true

module Lightning
  module Onion
    module Sphinx
      def self.compute_ephemereal_public_keys_and_shared_secrets(session_key, public_keys)
        point = ECDSA::Group::Secp256k1.generator
        generator_pubkey = ECDSA::Format::PointOctetString.encode(point, compression: true)
        ephemereal_public_key0 = make_blind(generator_pubkey.bth, session_key)
        secret0 = compute_shared_secret(public_keys[0], session_key)
        blinding_factor0 = compute_blinding_factor(ephemereal_public_key0, secret0)
        internal_compute_ephemereal_public_keys_and_shared_secrets(session_key, public_keys[1..-1], [ephemereal_public_key0], [blinding_factor0], [secret0])
      end

      def self.internal_compute_ephemereal_public_keys_and_shared_secrets(session_key, public_keys, ephemereal_public_keys, blinding_factors, shared_secrets)
        if public_keys.empty?
          [ephemereal_public_keys, shared_secrets]
        else
          ephemereal_public_key = make_blind(ephemereal_public_keys.last, blinding_factors.last)
          secret = compute_shared_secret(make_blinds(public_keys.first, blinding_factors), session_key)
          blinding_factor = compute_blinding_factor(ephemereal_public_key, secret)
          ephemereal_public_keys << ephemereal_public_key
          blinding_factors << blinding_factor
          shared_secrets << secret
          internal_compute_ephemereal_public_keys_and_shared_secrets(session_key, public_keys[1..-1], ephemereal_public_keys, blinding_factors, shared_secrets)
        end
      end

      def self.make_blind(public_key, blinding_factor)
        point = Bitcoin::Key.new(pubkey: public_key).to_point
        scalar = ECDSA::Format::IntegerOctetString.decode(blinding_factor.htb)
        point = point.multiply_by_scalar(scalar)
        public_key = ECDSA::Format::PointOctetString.encode(point, compression: true)
        public_key.bth
      end

      def self.make_blinds(public_key, blinding_factors)
        blinding_factors.inject(public_key) { |p, factor| make_blind(p, factor) }
      end

      def self.compute_shared_secret(public_key, secret)
        scalar = ECDSA::Format::IntegerOctetString.decode(secret.htb)
        point = Bitcoin::Key.new(pubkey: public_key).to_point.multiply_by_scalar(scalar)
        public_key = ECDSA::Format::PointOctetString.encode(point, compression: true)
        Bitcoin.sha256(public_key).bth
      end

      def self.compute_blinding_factor(public_key, secret)
        Bitcoin.sha256(public_key.htb + secret.htb).bth
      end

      def self.generate_filler(key_type, shared_secrets, hop_size, max_number_of_hops = 20)
        shared_secrets.inject([]) do |padding, secret|
          key = generate_key(key_type, secret)
          padding1 = padding + [0] * hop_size
          stream = generate_cipher_stream(key, hop_size * (max_number_of_hops + 1))
          stream = stream.reverse[0..padding1.size].reverse.unpack('c*')
          new_padding = xor(padding1, stream)
          new_padding
        end.pack('C*').bth
      end

      module KeyType
        RHO = 0x72686F
        MU = 0x6d75
        UM = 0x756d
      end

      # Key generation
      def self.generate_key(key_type, secret)
        OpenSSL::HMAC.digest(OpenSSL::Digest::SHA256.new, key_type, secret.htb)
      end

      def self.generate_cipher_stream(key, length)
        # FIXME: ChaCha20Poly1305Legacy encrypt should be 0-counter
        cipher = RbNaCl::AEAD::ChaCha20Poly1305Legacy.new(key)
        cipher.encrypt("\x00" * 8, "\x00" * length, '').bth[0..-32].htb
      end

      def self.xor(a, b)
        a.zip(b).map { |x, y| ((x ^ y) & 0xff) }
      end
    end
  end
end
