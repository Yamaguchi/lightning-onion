# frozen_string_literal: true

module Lightning
  module Onion
    class Packet
      attr_accessor :version, :public_key, :routing_info, :hmac
      def initialize(version, public_key, routing_info, hmac)
        @version = version
        @public_key = public_key
        @routing_info = routing_info
        raise "invalid size #{routing_info.size}" unless routing_info.size == 1300 * 2
        @hmac = hmac
      end

      def self.parse(payload)
        version, public_key, rest = payload.unpack('aH66a*')
        routing_info = rest[0...20 * 65].bth
        hmac = rest[20 * 65..-1].bth
        new(version, public_key, routing_info, hmac)
      end

      def to_payload
        payload = +''
        payload << [version, public_key].pack('aH66')
        payload << routing_info.htb
        payload << hmac.htb
        payload
      end
    end
  end
end
