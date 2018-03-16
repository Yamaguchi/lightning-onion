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
