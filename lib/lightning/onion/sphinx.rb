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
    end
  end
end
