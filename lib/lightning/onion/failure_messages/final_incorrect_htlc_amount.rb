# frozen_string_literal: true

module Lightning
  module Onion
    module FailureMessages
      module FinalIncorrectHtlcAmount
        def to_payload
          [type_code, incoming_htlc_amt].pack('nq>')
        end

        def self.load(payload)
          new(*payload.unpack('nq>'))
        end
      end
    end
  end
end
