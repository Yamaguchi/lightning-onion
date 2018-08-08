# frozen_string_literal: true

module Lightning
  module Onion
    module FailureMessages
      module InvalidRealm
        def to_payload
          [TYPES[:invalid_realm]].pack('n')
        end

        def self.load(_)
          InvalidRealm
        end
      end
    end
  end
end
