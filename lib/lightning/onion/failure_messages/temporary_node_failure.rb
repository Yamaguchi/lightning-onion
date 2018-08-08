# frozen_string_literal: true

module Lightning
  module Onion
    module FailureMessages
      module TemporaryNodeFailure
        def to_payload
          [TYPES[:temporary_node_failure]].pack('n')
        end

        def self.load(payload)
          TemporaryNodeFailure
        end
      end
    end
  end
end
