# frozen_string_literal: true

module Lightning
  module Onion
    module FailureMessages
      module PermanentNodeFailure
        def to_payload
          [TYPES[:permanent_node_failure]].pack('n')
        end

        def self.load(payload)
          PermanentNodeFailure
        end
      end
    end
  end
end
