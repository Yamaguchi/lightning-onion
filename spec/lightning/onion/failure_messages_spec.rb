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
    Lightning::Onion::FailureMessages::InvalidRealm[PERM | 1],
    Lightning::Onion::FailureMessages::TemporaryNodeFailure[NODE | 2],
    Lightning::Onion::FailureMessages::PermanentNodeFailure[PERM | NODE | 2],
    Lightning::Onion::FailureMessages::RequiredNodeFeatureMissing[PERM | NODE | 3],
    Lightning::Onion::FailureMessages::InvalidOnionVersion[BADONION | PERM | 4, SecureRandom.hex(64)],
    Lightning::Onion::FailureMessages::InvalidOnionHmac[BADONION | PERM | 5, SecureRandom.hex(64)],
    Lightning::Onion::FailureMessages::InvalidOnionKey[BADONION | PERM | 6, SecureRandom.hex(64)],
    Lightning::Onion::FailureMessages::TemporaryChannelFailure[UPDATE | 7, channel_update],
    Lightning::Onion::FailureMessages::PermanentChannelFailure[PERM | 8],
    Lightning::Onion::FailureMessages::RequiredChannelFeatureMissing[PERM | 9],
    Lightning::Onion::FailureMessages::UnknownNextPeer[PERM | 10],
    Lightning::Onion::FailureMessages::AmountBelowMinimum[UPDATE | 11, 123_456, channel_update],
    Lightning::Onion::FailureMessages::FeeInsufficient[UPDATE | 12, 546_463, channel_update],
    Lightning::Onion::FailureMessages::IncorrectCltvExpiry[UPDATE | 13, 1_211, channel_update],
    Lightning::Onion::FailureMessages::ExpiryTooSoon[UPDATE | 14, channel_update],
    Lightning::Onion::FailureMessages::UnknownPaymentHash[PERM | 15],
    Lightning::Onion::FailureMessages::IncorrectPaymentAmount[PERM | 16],
    Lightning::Onion::FailureMessages::FinalExpiryTooSoon[17],
    Lightning::Onion::FailureMessages::FinalIncorrectCltvExpiry[18, 1_234],
    Lightning::Onion::FailureMessages::FinalIncorrectHtlcAmount[19],
    Lightning::Onion::FailureMessages::ChannelDisabled[20, '0101', channel_update],
    Lightning::Onion::FailureMessages::ExpiryTooFar[21]
  ].each do |message|
    encoded = message.to_payload
    decoded = Lightning::Onion::FailureMessages.load(encoded)
    describe "#{message} to_payload / load" do
      it { expect(decoded).to eq message }
    end
  end
end
