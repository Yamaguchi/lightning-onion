# frozen_string_literal: true

module Lightning
  module Onion
    module FailureMessages
      module IncorrectPaymentAmount
        def to_payload
          [TYPES[:incorrect_payment_amount]].pack('n')
        end

        def self.load(_)
          IncorrectPaymentAmount
        end
      end
    end
  end
end
