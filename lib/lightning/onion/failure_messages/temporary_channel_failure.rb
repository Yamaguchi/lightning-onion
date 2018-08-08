# frozen_string_literal: true

module Lightning
  module Onion
    module FailureMessages
      module TemporaryChannelFailure
        def to_payload
          [TYPES[:temporary_channel_failure], channel_update.bytesize].pack('n2') + channel_update.htb
        end

        def self.load(payload)
          len, rest = payload.unpack('nH*')
          new(rest[0..len * 2])
        end
      end
    end
  end
end
