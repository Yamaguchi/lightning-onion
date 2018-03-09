# frozen_string_literal: true

module Lightning
  module Onion
    class Packet
      attr_accessor :version, :public_key, :hops_data, :hmac
      def initialize(version, public_key, hops_data, hmac)
        @version = version
        @public_key = public_key
        @hops_data = []
        20.times do |i|
          payload = hops_data[i * 65...i * 65 + 65]
          @hops_data << Lightning::Onion::HopsData.parse(payload)
        end
        @hmac = hmac
      end
    end
  end
end
