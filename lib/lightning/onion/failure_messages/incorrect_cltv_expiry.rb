# frozen_string_literal: true

module Lightning
  module Onion
    module FailureMessages
      module IncorrectCltvExpiry
        def to_payload
          [type_code, cltv_expiry, channel_update.htb.bytesize].pack('nq>n') + channel_update.htb
        end

        def self.load(payload)
          type_code, cltv_expiry, len, rest = payload.unpack('nq>nH*')
          new(type_code, cltv_expiry, rest[0..len * 2])
        end
      end
    end
  end
end
