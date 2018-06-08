# frozen_string_literal: true

module Lightning
  module Onion
    module Sphinx
      VERSION = "\x00"
      PAYLOAD_LENGTH = 33
      MAC_LENGTH = 32
      MAX_HOPS = 20
      HOP_LENGTH = PAYLOAD_LENGTH + MAC_LENGTH
      MAX_ERROR_PAYLOAD_LENGTH = 256
      ERROR_PACKET_LENGTH = MAC_LENGTH + MAX_ERROR_PAYLOAD_LENGTH + 2 + 2

      LAST_PACKET = Lightning::Onion::Packet.new(VERSION, "\x00" * 33, '00' * MAX_HOPS * HOP_LENGTH, '00' * MAC_LENGTH)

      def self.make_packet(session_key, public_keys, payloads, associated_data)
        ephemereal_public_keys, shared_secrets = compute_keys_and_secrets(session_key, public_keys)
        filler = generate_filler('rho', shared_secrets[0...-1], HOP_LENGTH, MAX_HOPS)
        last_packet = make_next_packet(
          payloads.last,
          associated_data,
          ephemereal_public_keys.last,
          shared_secrets.last,
          LAST_PACKET,
          filler
        )
        packet = internal_make_packet(
          payloads[0...-1],
          ephemereal_public_keys[0...-1],
          shared_secrets[0...-1],
          last_packet,
          associated_data
        )
        [packet, shared_secrets.zip(public_keys)]
      end

      # @return payload 33bytes payload of the outermost layer of onions,which including realm
      # @return packet
      def self.parse(private_key, raw_packet)
        packet = Lightning::Onion::Packet.parse(raw_packet)
        shared_secret = compute_shared_secret(packet.public_key, private_key)
        rho = generate_key('rho', shared_secret)
        bin = xor(
          (packet.routing_info + '00' * HOP_LENGTH).htb.unpack('C*'),
          generate_cipher_stream(rho, HOP_LENGTH + MAX_HOPS * HOP_LENGTH).unpack('C*')
        )
        payload = bin[0...HOP_LENGTH].pack('C*')
        hmac = bin[PAYLOAD_LENGTH...HOP_LENGTH].pack('C*')
        next_hops_data = bin[HOP_LENGTH..-1]

        next_public_key = make_blind(packet.public_key, compute_blinding_factor(packet.public_key, shared_secret))
        routing_info = next_hops_data.pack('C*').bth
        [Lightning::Onion::HopData.parse(payload), Lightning::Onion::Packet.new(VERSION, next_public_key, routing_info, hmac.bth), shared_secret]
      end

      def self.internal_make_packet(hop_payloads, keys, shared_secrets, packet, associated_data)
        return packet if hop_payloads.empty?
        next_packet = make_next_packet(hop_payloads.last, associated_data, keys.last, shared_secrets.last, packet)
        internal_make_packet(hop_payloads[0...-1], keys[0...-1], shared_secrets[0...-1], next_packet, associated_data)
      end

      def self.make_next_packet(payload, associated_data, ephemereal_public_key, shared_secret, packet, filler = '')
        hops_data1 = payload.htb << packet.hmac.htb << packet.routing_info.htb[0...-HOP_LENGTH]
        rho_key = generate_key('rho', shared_secret)
        stream = generate_cipher_stream(rho_key, MAX_HOPS * HOP_LENGTH)
        hops_data2 = xor(hops_data1.unpack('C*'), stream.unpack('C*'))
        next_hops_data =
          if filler.empty?
            hops_data2
          else
            hops_data2[0...-filler.htb.unpack('C*').size] + filler.htb.unpack('C*')
          end
        mu_key = generate_key('mu', shared_secret)
        next_hmac = mac(mu_key, next_hops_data + associated_data.htb.unpack('C*'))
        routing_info = next_hops_data.pack('C*').bth
        Lightning::Onion::Packet.new(VERSION, ephemereal_public_key, routing_info, next_hmac.bth)
      end

      def self.compute_keys_and_secrets(session_key, public_keys)
        point = ECDSA::Group::Secp256k1.generator
        generator_pubkey = ECDSA::Format::PointOctetString.encode(point, compression: true)
        ephemereal_public_key0 = make_blind(generator_pubkey.bth, session_key)
        secret0 = compute_shared_secret(public_keys[0], session_key)
        blinding_factor0 = compute_blinding_factor(ephemereal_public_key0, secret0)
        internal_compute_keys_and_secrets(
          session_key,
          public_keys[1..-1],
          [ephemereal_public_key0],
          [blinding_factor0],
          [secret0]
        )
      end

      def self.internal_compute_keys_and_secrets(
        session_key,
        public_keys,
        ephemereal_public_keys,
        blinding_factors,
        shared_secrets
      )
        if public_keys.empty?
          [ephemereal_public_keys, shared_secrets]
        else
          ephemereal_public_key = make_blind(ephemereal_public_keys.last, blinding_factors.last)
          secret = compute_shared_secret(make_blinds(public_keys.first, blinding_factors), session_key)
          blinding_factor = compute_blinding_factor(ephemereal_public_key, secret)
          ephemereal_public_keys << ephemereal_public_key
          blinding_factors << blinding_factor
          shared_secrets << secret
          internal_compute_keys_and_secrets(
            session_key,
            public_keys[1..-1],
            ephemereal_public_keys,
            blinding_factors,
            shared_secrets
          )
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

      def self.generate_filler(key_type, shared_secrets, hop_size, max_number_of_hops = MAX_HOPS)
        shared_secrets.inject([]) do |padding, secret|
          key = generate_key(key_type, secret)
          padding1 = padding + [0] * hop_size
          stream = generate_cipher_stream(key, hop_size * (max_number_of_hops + 1))
          stream = stream.reverse[0...padding1.size].reverse.unpack('c*')
          new_padding = xor(padding1, stream)
          new_padding
        end.pack('C*').bth
      end

      def self.hmac256(key, message)
        OpenSSL::HMAC.digest(OpenSSL::Digest::SHA256.new, key, message)
      end

      # Key generation
      def self.generate_key(key_type, secret)
        hmac256(key_type, secret.htb)
      end

      def self.generate_cipher_stream(key, length)
        Lightning::Onion::ChaCha20.chacha20_encrypt(key, 0, "\x00" * 12, "\x00" * length)
      end

      def self.xor(a, b)
        a.zip(b).map { |x, y| ((x ^ y) & 0xff) }
      end

      def self.mac(key, message)
        hmac256(key, message.pack('C*'))[0...MAC_LENGTH]
      end

      def self.make_error_packet(shared_secret, failure)
        message = failure.to_payload
        um = generate_key('um', shared_secret)
        padlen = MAX_ERROR_PAYLOAD_LENGTH - message.length
        payload = +''
        payload << [message.length].pack('n')
        payload << message
        payload << [padlen].pack('n')
        payload << "\x00" * padlen
        forward_error_packet(mac(um, payload.unpack('C*')) + payload, shared_secret)
      end

      def self.forward_error_packet(payload, shared_secret)
        key = generate_key('ammag', shared_secret)
        stream = generate_cipher_stream(key, ERROR_PACKET_LENGTH)
        xor(payload.unpack('C*'), stream.unpack('C*')).pack('C*')
      end

      def self.parse_error(payload, node_shared_secrets)
        raise "invalid length: #{payload.htb.bytesize}" unless payload.htb.bytesize == ERROR_PACKET_LENGTH
        internal_parse_error(payload.htb, node_shared_secrets)
      end

      def self.internal_parse_error(payload, node_shared_secrets)
        raise RuntimeError unless node_shared_secrets
        node_shared_secret = node_shared_secrets.last
        next_payload = forward_error_packet(payload, node_shared_secret[0])
        if check_mac(node_shared_secret[0], next_payload)
          ErrorPacket.new(node_shared_secret[1], extract_failure_message(next_payload))
        else
          internal_parse_error(next_payload, node_shared_secrets[0...-1])
        end
      end

      def self.check_mac(secret, payload)
        mac = payload[0...MAC_LENGTH]
        payload1 = payload[MAC_LENGTH..-1]
        um = generate_key('um', secret)
        mac == mac(um, payload1.unpack('C*'))
      end

      def self.extract_failure_message(payload)
        raise "invalid length: #{payload.bytesize}" unless payload.bytesize == ERROR_PACKET_LENGTH
        _mac, len, rest = payload.unpack("a#{MAC_LENGTH}na*")
        FailureMessages.load(rest[0...len])
      end
    end
  end
end
