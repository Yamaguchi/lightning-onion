# frozen_string_literal: true

module Lightning
  module Onion
    module FailureMessage
      # unparsable onion encrypted by sending peer
      BADONION = 0x8000

      # permanent failure (otherwise transient)
      PERM = 0x4000

      # node failure (otherwise channel)
      NODE = 0x2000

      # new channel update enclosed
      UPDATE = 0x1000

      class InvalidRealm
        def type
          PERM | 1
        end

        def to_payload
          type
        end
      end

      class TemporaryNodeFailure
        def type
          NODE | 2
        end

        def to_payload
          type
        end
      end
    end
  end
end
