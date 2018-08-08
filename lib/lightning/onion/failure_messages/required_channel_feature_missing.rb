# frozen_string_literal: true

module Lightning
  module Onion
    module FailureMessages
      module RequiredChannelFeatureMissing
        def to_payload
          [TYPES[:required_channel_feature_missing]].pack('n')
        end

        def self.load(payload)
          RequiredChannelFeatureMissing
        end
      end
    end
  end
end
