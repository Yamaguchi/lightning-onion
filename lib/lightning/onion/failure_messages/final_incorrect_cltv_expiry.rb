# frozen_string_literal: true

module Lightning
  module Onion
    module FailureMessages
      module FinalIncorrectCltvExpiry
        def to_payload
          [type_code, cltv_expiry].pack('nq>')
        end

        def self.load(payload)
          new(*payload.unpack('nq>'))
        end
      end
    end
  end
end
