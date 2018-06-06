# frozen_string_literal: true

module Lightning
  module Onion
    class PerHop
      attr_accessor :short_channel_id, :amt_to_forward, :outgoing_cltv_value, :padding
      def initialize(short_channel_id, amt_to_forward, outgoing_cltv_value, padding)
        @short_channel_id = short_channel_id
        @amt_to_forward = amt_to_forward
        @outgoing_cltv_value = outgoing_cltv_value
        @padding = padding
      end

      def self.parse(payload)
        new(*payload.unpack('Q>2Na16'))
      end

      def to_payload
        [short_channel_id, amt_to_forward, outgoing_cltv_value, padding].pack('Q>2Na12')
      end
      LAST_NODE = PerHop.parse("\x00" * 32)
    end
  end
end
