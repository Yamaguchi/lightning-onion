# frozen_string_literal: true

module Lightning
  module Onion
    module FailureMessages
      module PermanentChannelFailure
        def to_payload
          [TYPES[:permanent_channel_failure]].pack('n')
        end

        def self.load(_)
          PermanentChannelFailure
        end
      end
    end
  end
end
