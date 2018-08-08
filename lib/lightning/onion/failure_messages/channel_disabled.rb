# frozen_string_literal: true

module Lightning
  module Onion
    module FailureMessages
      module ChannelDisabled
        def to_payload
          [TYPES[:channel_disabled], flags, channel_update.htb.bytesize].pack('nH4n') + channel_update.htb
        end

        def self.load(payload)
          flags, len, rest = payload.unpack('H4nH*')
          new(flags, rest[0..len * 2])
        end
      end
    end
  end
end
