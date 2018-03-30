# frozen_string_literal: true

module Lightning
  module Onion
    module FailureMessages
      module InvalidOnionVersion
        def to_payload
          [type_code, sha256_of_onion.htb.bytesize].pack('nn') + sha256_of_onion.htb
        end

        def self.load(payload)
          type_code, len, rest = payload.unpack('nnH*')
          new(type_code, rest[0..len * 2])
        end
      end
    end
  end
end
