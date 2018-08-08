# frozen_string_literal: true

module Lightning
  module Onion
    module FailureMessages
      module FinalExpiryTooSoon
        def to_payload
          [TYPES[:final_expiry_too_soon]].pack('n')
        end

        def self.load(_)
          FinalExpiryTooSoon
        end
      end
    end
  end
end
