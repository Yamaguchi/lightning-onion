# frozen_string_literal: true

module Lightning
  module Onion
    class Packet
      attr_accessor :version, :public_key, :routing_info, :hmac

      def initialize(version, public_key, routing_info, hmac)
        @version = version
        @public_key = public_key
        @routing_info = routing_info
        raise "invalid size #{routing_info.size}" unless routing_info.size == Packet.routing_bytesize * 2
        @hmac = hmac
      end

      def self.routing_bytesize
        Lightning::Onion::Sphinx::MAX_HOPS * Lightning::Onion::Sphinx::HOP_LENGTH
      end

      def self.parse(payload)
        version, public_key, rest = payload.unpack('aH66a*')
        routing_info = rest[0...routing_bytesize].bth
        hmac = rest[routing_bytesize..-1].bth
        new(version, public_key, routing_info, hmac)
      end

      def to_payload
        payload = +''
        payload << [version, public_key].pack('aH66')
        payload << routing_info.htb
        payload << hmac.htb
        payload
      end

      def last?
        hmac == '00' * 32
      end
    end
  end
end
