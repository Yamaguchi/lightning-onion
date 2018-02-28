# frozen_string_literal: true

module Lightning
  module Onion
    class HopData
      attr_accessor :realm, :per_hop, :hmac
      def initialize(realm, per_hop, hmac)
        @realm = realm
        @per_hop = per_hop
        @hmac = hmac
      end

      def self.parse(payload)
        realm, per_hop_payload, hmac = payload.unpack('Ca32a32')
        per_hop = Lightning::Onion::PerHop.parse(per_hop_payload)
        new(realm, per_hop, hmac)
      end
    end
  end
end
