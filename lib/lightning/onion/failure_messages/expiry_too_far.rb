# frozen_string_literal: true

module Lightning
  module Onion
    module FailureMessages
      module ExpiryTooFar
        def to_payload
          [TYPES[:expiry_too_far]].pack('n')
        end

        def self.load(payload)
          ExpiryTooFar
        end
      end
    end
  end
end
