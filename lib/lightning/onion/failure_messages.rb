# frozen_string_literal: true

module Lightning
  module Onion
    module FailureMessages
      # unparsable onion encrypted by sending peer
      BADONION = 0x8000

      # permanent failure (otherwise transient)
      PERM = 0x4000

      # node failure (otherwise channel)
      NODE = 0x2000

      # new channel update enclosed
      UPDATE = 0x1000

      def to_payload
        type
      end

      TYPES = {
        invalid_realm: PERM | 1,
        temporary_node_failure: NODE | 2,
        permanent_node_failure: PERM | NODE | 2,
        required_node_feature_missing: PERM | NODE | 3,
        invalid_onion_version: BADONION | PERM | 4,
        invalid_onion_hmac: BADONION | PERM | 5,
        invalid_onion_key: BADONION | PERM | 6,
        temporary_channel_failure: UPDATE | 7,
        permanent_channel_failure: PERM | 8,
        required_channel_feature_missing: PERM | 9,
        unknown_next_peer: PERM | 10,
        amount_below_minimum: UPDATE | 11,
        fee_insufficient: UPDATE | 12,
        incorrect_cltv_expiry: UPDATE | 13,
        expiry_too_soon: UPDATE | 14,
        unknown_payment_hash: PERM | 15,
        incorrect_payment_amount: PERM | 16,
        final_expiry_too_soon: 17,
        final_incorrect_cltv_expiry: 18,
        final_incorrect_htlc_amount: 19,
        channel_disabled: 20,
        expiry_too_far: 21
      }.freeze

      FailureMessage = Algebrick.type do
        InvalidRealm = atom
        TemporaryNodeFailure = atom
        PermanentNodeFailure = atom
        RequiredNodeFeatureMissing = atom
        InvalidOnionVersion = type do
          fields! sha256_of_onion: String
        end
        InvalidOnionHmac = type do
          fields! sha256_of_onion: String
        end
        InvalidOnionKey = type do
          fields! sha256_of_onion: String
        end
        TemporaryChannelFailure = type do
          fields! channel_update: String
        end
        PermanentChannelFailure = atom
        RequiredChannelFeatureMissing = atom
        UnknownNextPeer = atom
        AmountBelowMinimum = type do
          fields! htlc_msat: Numeric,
                  channel_update: String
        end
        FeeInsufficient = type do
          fields! htlc_msat: Numeric,
                  channel_update: String
        end
        IncorrectCltvExpiry = type do
          fields! cltv_expiry: Numeric,
                  channel_update: String
        end
        ExpiryTooSoon = type do
          fields! channel_update: String
        end
        UnknownPaymentHash = atom
        IncorrectPaymentAmount = atom
        FinalExpiryTooSoon = atom
        FinalIncorrectCltvExpiry = type do
          fields! cltv_expiry: Numeric
        end
        FinalIncorrectHtlcAmount = type do
          fields! incoming_htlc_amt: Numeric
        end
        ChannelDisabled = type do
          fields! flags: Numeric,
                  channel_update: String
        end
        ExpiryTooFar = atom
        variants  InvalidRealm,
                  TemporaryNodeFailure,
                  PermanentNodeFailure,
                  RequiredNodeFeatureMissing,
                  InvalidOnionVersion,
                  InvalidOnionHmac,
                  InvalidOnionKey,
                  TemporaryChannelFailure,
                  PermanentChannelFailure,
                  RequiredChannelFeatureMissing,
                  UnknownNextPeer,
                  AmountBelowMinimum,
                  FeeInsufficient,
                  IncorrectCltvExpiry,
                  ExpiryTooSoon,
                  UnknownPaymentHash,
                  IncorrectPaymentAmount,
                  FinalExpiryTooSoon,
                  FinalIncorrectCltvExpiry,
                  FinalIncorrectHtlcAmount,
                  ChannelDisabled,
                  ExpiryTooFar
      end
      module FailureMessage
        def to_payload
          key = name.split('::').last.gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').gsub(/([a-z\d])([A-Z])/, '\1_\2').tr("-", "_").downcase
          TYPES[key.to_sym].to_s(16).htb
        end
      end
      autoload :InvalidRealm, 'lib/lightning/onion/failure_message/invalid_realm'
      autoload :TemporaryNodeFailure, 'lib/lightning/onion/failure_message/temporary_node_failure'
      autoload :PermanentNodeFailure, 'lib/lightning/onion/failure_message/permanent_node_failure'
      autoload :RequiredNodeFeatureMissing, 'lib/lightning/onion/failure_message/required_node_feature_missing'
      autoload :InvalidOnionVersion, 'lib/lightning/onion/failure_message/invalid_onion_version'
      autoload :InvalidOnionHmac, 'lib/lightning/onion/failure_message/invalid_onion_hmac'
      autoload :InvalidOnionKey, 'lib/lightning/onion/failure_message/invalid_onion_key'
      autoload :TemporaryChannelFailure, 'lib/lightning/onion/failure_message/temporary_channel_failure'
      autoload :PermanentChannelFailure, 'lib/lightning/onion/failure_message/permanent_channel_failure'
      autoload :RequiredChannelFeatureMissing, 'lib/lightning/onion/failure_message/required_channel_feature_missing'
      autoload :UnknownNextPeer, 'lib/lightning/onion/failure_message/unknown_next_peer'
      autoload :AmountBelowMinimum, 'lib/lightning/onion/failure_message/amount_below_minimum'
      autoload :FeeInsufficient, 'lib/lightning/onion/failure_message/fee_insufficient'
      autoload :IncorrectCltvExpiry, 'lib/lightning/onion/failure_message/incorrect_cltv_expiry'
      autoload :ExpiryTooSoon, 'lib/lightning/onion/failure_message/expiry_too_soon'
      autoload :UnknownPaymentHash, 'lib/lightning/onion/failure_message/unknown_payment_hash'
      autoload :IncorrectPaymentAmount, 'lib/lightning/onion/failure_message/incorrect_payment_amount'
      autoload :FinalExpiryTooSoon, 'lib/lightning/onion/failure_message/final_expiry_too_soon'
      autoload :FinalIncorrectCltvExpiry, 'lib/lightning/onion/failure_message/final_incorrect_cltv_expiry'
      autoload :FinalIncorrectHtlcAmount, 'lib/lightning/onion/failure_message/final_incorrect_htlc_amount'
      autoload :ChannelDisabled, 'lib/lightning/onion/failure_message/channel_disabled'
      autoload :ExpiryTooFar, 'lib/lightning/onion/failure_message/expiry_too_far'
    end
  end
end
