# frozen_string_literal: true

module Lightning
  module Onion
    module FailureMessages
      module InvalidOnionVersion
        def to_payload
          [TYPES[:invalid_onion_version], sha256_of_onion.htb.bytesize].pack('n2') + sha256_of_onion.htb
        end

        def self.load(payload)
          len, rest = payload.unpack('nH*')
          new(rest[0..len * 2])
        end
      end
    end
  end
end
