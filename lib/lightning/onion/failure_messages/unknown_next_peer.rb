# frozen_string_literal: true

module Lightning
  module Onion
    module FailureMessages
      module UnknownNextPeer
        def to_payload
          [TYPES[:unknown_next_peer]].pack('n')
        end

        def self.load(payload)
          UnknownNextPeer
        end
      end
    end
  end
end
