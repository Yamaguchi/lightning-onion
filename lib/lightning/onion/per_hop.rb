# frozen_string_literal: true

module Lightning
  module Onion
    class PerHop
      attr_accessor :channel_id, :amt_to_forward, :outgoing_cltv_value, :padding
      def initialize(channel_id, amt_to_forward, outgoing_cltv_value, padding)
        @channel_id = channel_id
        @amt_to_forward = amt_to_forward
        @outgoing_cltv_value = outgoing_cltv_value
        @padding = padding
      end

      def self.parse(payload)
        new(*payload.unpack('a8N2a16'))
      end

      LAST_NODE = PerHop.parse("\x00" * 32)
    end
  end
end
