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
        InvalidRealm = type do
          fields! type_code: Numeric
        end
        TemporaryNodeFailure = type do
          fields! type_code: Numeric
        end
        PermanentNodeFailure = type do
          fields! type_code: Numeric
        end
        RequiredNodeFeatureMissing = type do
          fields! type_code: Numeric
        end
        InvalidOnionVersion = type do
          fields! type_code: Numeric,
                  sha256_of_onion: String
        end
        InvalidOnionHmac = type do
          fields! type_code: Numeric,
                  sha256_of_onion: String
        end
        InvalidOnionKey = type do
          fields! type_code: Numeric,
                  sha256_of_onion: String
        end
        TemporaryChannelFailure = type do
          fields! type_code: Numeric,
                  channel_update: String
        end
        PermanentChannelFailure = type do
          fields! type_code: Numeric
        end
        RequiredChannelFeatureMissing = type do
          fields! type_code: Numeric
        end
        UnknownNextPeer = type do
          fields! type_code: Numeric
        end
        AmountBelowMinimum = type do
          fields! type_code: Numeric,
                  htlc_msat: Numeric,
                  channel_update: String
        end
        FeeInsufficient = type do
          fields! type_code: Numeric,
                  htlc_msat: Numeric,
                  channel_update: String
        end
        IncorrectCltvExpiry = type do
          fields! type_code: Numeric,
                  cltv_expiry: Numeric,
                  channel_update: String
        end
        ExpiryTooSoon = type do
          fields! type_code: Numeric,
                  channel_update: String
        end
        UnknownPaymentHash = type do
          fields! type_code: Numeric
        end
        IncorrectPaymentAmount = type do
          fields! type_code: Numeric
        end
        FinalExpiryTooSoon = type do
          fields! type_code: Numeric
        end
        FinalIncorrectCltvExpiry = type do
          fields! type_code: Numeric,
                  cltv_expiry: Numeric
        end
        FinalIncorrectHtlcAmount = type do
          fields! type_code: Numeric,
                  incoming_htlc_amt: Numeric
        end
        ChannelDisabled = type do
          fields! type_code: Numeric,
                  flags: String,
                  channel_update: String
        end
        ExpiryTooFar = type do
          fields! type_code: Numeric
        end
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

      def self.load(payload)
        type, = payload.unpack('na*')
        message_class = FailureMessage.variants.find do |t|
          TYPES[t.name.split('::').last.snake.to_sym] == type
        end
        message_class.load(payload)
      end

      require 'lightning/onion/failure_messages/invalid_realm'
      require 'lightning/onion/failure_messages/temporary_node_failure'
      require 'lightning/onion/failure_messages/permanent_node_failure'
      require 'lightning/onion/failure_messages/required_node_feature_missing'
      require 'lightning/onion/failure_messages/invalid_onion_version'
      require 'lightning/onion/failure_messages/invalid_onion_hmac'
      require 'lightning/onion/failure_messages/invalid_onion_key'
      require 'lightning/onion/failure_messages/temporary_channel_failure'
      require 'lightning/onion/failure_messages/permanent_channel_failure'
      require 'lightning/onion/failure_messages/required_channel_feature_missing'
      require 'lightning/onion/failure_messages/unknown_next_peer'
      require 'lightning/onion/failure_messages/amount_below_minimum'
      require 'lightning/onion/failure_messages/fee_insufficient'
      require 'lightning/onion/failure_messages/incorrect_cltv_expiry'
      require 'lightning/onion/failure_messages/expiry_too_soon'
      require 'lightning/onion/failure_messages/unknown_payment_hash'
      require 'lightning/onion/failure_messages/incorrect_payment_amount'
      require 'lightning/onion/failure_messages/final_expiry_too_soon'
      require 'lightning/onion/failure_messages/final_incorrect_cltv_expiry'
      require 'lightning/onion/failure_messages/final_incorrect_htlc_amount'
      require 'lightning/onion/failure_messages/channel_disabled'
      require 'lightning/onion/failure_messages/expiry_too_far'
    end
  end
end
