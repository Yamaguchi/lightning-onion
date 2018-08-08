# frozen_string_literal: true

module Lightning
  module Onion
    module FailureMessages
      module FinalIncorrectHtlcAmount
        def to_payload
          [TYPES[:final_incorrect_htlc_amount], incoming_htlc_amt].pack('nq>')
        end

        def self.load(payload)
          new(*payload.unpack('q>'))
        end
      end
    end
  end
end
