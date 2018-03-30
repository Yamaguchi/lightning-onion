# frozen_string_literal: true

module Lightning
  module Onion
    module FailureMessages
      module TemporaryChannelFailure
        def to_payload
          [type_code, channel_update.bytesize].pack('nn') + channel_update.htb
        end

        def self.load(payload)
          type_code, len, rest = payload.unpack('nnH*')
          new(type_code, rest[0..len * 2])
        end
      end
    end
  end
end
