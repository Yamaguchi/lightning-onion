# frozen_string_literal: true

module Lightning
  module Onion
    class ErrorPacket
      attr_accessor :onion_node, :failure_message
      def initialize(onion_node, failure_message)
        @onion_node = onion_node
        @failure_message = failure_message
      end
    end
  end
end
