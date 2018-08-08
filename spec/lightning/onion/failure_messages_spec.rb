# frozen_string_literal: true

require 'spec_helper'

include Lightning::Onion::FailureMessages

describe Lightning::Onion::FailureMessages do
  channel_update =
    '01023b5969880d01a90c34ea3999eb78e6bd476603db6bd0ba96742a3e600b0e' \
    'aebc00aa488c80e8e949452b471bc6d5f15e48bd10c8b4cb1c3f7e76a55d6864' \
    '372506226e46111a0b59caaf126043eb5bbf28c34f3a5e332a1fc7b2b73cf188' \
    '910f000000000000000100000002020200030000000000000004000000050000' \
    '0006'

  [
    Lightning::Onion::FailureMessages::InvalidRealm,
    Lightning::Onion::FailureMessages::TemporaryNodeFailure,
    Lightning::Onion::FailureMessages::PermanentNodeFailure,
    Lightning::Onion::FailureMessages::RequiredNodeFeatureMissing,
    Lightning::Onion::FailureMessages::InvalidOnionVersion[SecureRandom.hex(64)],
    Lightning::Onion::FailureMessages::InvalidOnionHmac[SecureRandom.hex(64)],
    Lightning::Onion::FailureMessages::InvalidOnionKey[SecureRandom.hex(64)],
    Lightning::Onion::FailureMessages::TemporaryChannelFailure[channel_update],
    Lightning::Onion::FailureMessages::PermanentChannelFailure,
    Lightning::Onion::FailureMessages::RequiredChannelFeatureMissing,
    Lightning::Onion::FailureMessages::UnknownNextPeer,
    Lightning::Onion::FailureMessages::AmountBelowMinimum[123_456, channel_update],
    Lightning::Onion::FailureMessages::FeeInsufficient[546_463, channel_update],
    Lightning::Onion::FailureMessages::IncorrectCltvExpiry[1_211, channel_update],
    Lightning::Onion::FailureMessages::ExpiryTooSoon[channel_update],
    Lightning::Onion::FailureMessages::UnknownPaymentHash,
    Lightning::Onion::FailureMessages::IncorrectPaymentAmount,
    Lightning::Onion::FailureMessages::FinalExpiryTooSoon,
    Lightning::Onion::FailureMessages::FinalIncorrectCltvExpiry[123_456],
    Lightning::Onion::FailureMessages::FinalIncorrectHtlcAmount[123_456_789],
    Lightning::Onion::FailureMessages::ChannelDisabled['0101', channel_update],
    Lightning::Onion::FailureMessages::ExpiryTooFar
  ].each do |message|
    encoded = message.to_payload
    decoded = Lightning::Onion::FailureMessages.load(encoded)
    describe "#{message} to_payload / load" do
      it { expect(decoded).to eq message }
    end
  end
end
