# frozen_string_literal: true

module Lightning
  module Onion
    module FailureMessages
      module UnknownPaymentHash
        def to_payload
          [type_code].pack('n')
        end

        def self.load(payload)
          new(*payload.unpack('n'))
        end
      end
    end
  end
end
