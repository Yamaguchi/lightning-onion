# frozen_string_literal: true

module Lightning
  module Onion
    module FailureMessages
      module ChannelDisabled
        def to_payload
          [type_code].pack('n') + flags + [channel_update.htb.bytesize].pack('n') + channel_update.htb
        end

        def self.load(payload)
          type_code, flags, len, rest = payload.unpack('na4nH*')
          new(type_code, flags, rest[0..len * 2])
        end
      end
    end
  end
end
