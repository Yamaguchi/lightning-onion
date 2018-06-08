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
        new(*payload.unpack('Q>2Na12'))
      end
      LAST_NODE = PerHop.parse("\x00" * 32)

      def to_payload
        to_a.pack('Q>2Na12')
      end

      def ==(other)
        other.class == self.class && other.to_a == to_a
      end

      alias eql? ==

      def hash
        to_a.hash
      end

      protected

      def to_a
        [short_channel_id, amt_to_forward, outgoing_cltv_value, padding]
      end
    end
  end
end
