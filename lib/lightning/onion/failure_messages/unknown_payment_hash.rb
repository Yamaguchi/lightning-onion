# frozen_string_literal: true

module Lightning
  module Onion
    module FailureMessages
      module UnknownPaymentHash
        def to_payload
          [TYPES[:unknown_payment_hash]].pack('n')
        end

        def self.load(_)
          UnknownPaymentHash
        end
      end
    end
  end
end
