# frozen_string_literal: true

module Lightning
  module Onion
    module FailureMessages
      module FinalIncorrectCltvExpiry
        def to_payload
          [TYPES[:final_incorrect_cltv_expiry], cltv_expiry].pack('nq>')
        end

        def self.load(payload)
          new(*payload.unpack('q>'))
        end
      end
    end
  end
end
