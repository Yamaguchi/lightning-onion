# frozen_string_literal: true

module Lightning
  module Onion
    class Packet
      attr_accessor :version, :public_key, :hops_data, :hmac
      def initialize(version, public_key, hops_data, hmac)
        @version = version
        @public_key = public_key
        @hops_data = hops_data
        @hmac = hmac
      end

      def self.parse(payload)
        version, public_key, rest = payload.unpack('H2H66a*')
        hops_data = []
        20.times do |i|
          hops_data << Lightning::Onion::HopData.parse(rest[i * 65...i * 65 + 65])
        end
        hmac = rest[21 * 65..-1]
        new(version, public_key, hops_data, hmac)
      end

      def to_payload
        payload = +''
        payload << [version.bth, public_key].pack('H2H66')
        payload << [hops_data.map(&:to_payload).join].pack('a1300')
        payload << hmac
        payload
      end
    end
  end
end
