# frozen_string_literal: true

module Lightning
  module Onion
    module FailureMessages
      module RequiredNodeFeatureMissing
        def to_payload
          [TYPES[:required_node_feature_missing]].pack('n')
        end

        def self.load(payload)
          RequiredNodeFeatureMissing
        end
      end
    end
  end
end
