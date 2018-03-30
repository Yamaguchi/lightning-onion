# frozen_string_literal: true

module Lightning
  module Onion
    module FailureMessages
      module AmountBelowMinimum
        def to_payload
          [type_code, htlc_msat, channel_update.htb.bytesize].pack('nq>n') + channel_update.htb
        end

        def self.load(payload)
          type_code, htlc_msat, len, rest = payload.unpack('nq>nH*')
          new(type_code, htlc_msat, rest[0..len * 2])
        end
      end
    end
  end
end
