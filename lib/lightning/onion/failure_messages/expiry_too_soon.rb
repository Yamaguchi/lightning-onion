# frozen_string_literal: true

module Lightning
  module Onion
    module FailureMessages
      module ExpiryTooSoon
        def to_payload
          [TYPES[:expiry_too_soon], channel_update.htb.bytesize].pack('n2') + channel_update.htb
        end

        def self.load(payload)
          len, rest = payload.unpack('nH*')
          new(rest[0..len * 2])
        end
      end
    end
  end
end
