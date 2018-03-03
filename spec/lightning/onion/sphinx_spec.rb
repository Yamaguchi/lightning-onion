# frozen_string_literal: true

require 'spec_helper'

describe Lightning::Onion::Sphinx do
  describe '.compute_ephemereal_public_keys_and_shared_secrets' do
    let(:public_keys) do
      [
        '02eec7245d6b7d2ccb30380bfbe2a3648cd7a942653f5aa340edcea1f283686619',
        '0324653eac434488002cc06bbfb7f10fe18991e35f9fe4302dbea6d2353dc0ab1c',
        '027f31ebc5462c1fdce1b737ecff52d37d75dea43ce11c74d25aa297165faa2007',
        '032c0b7cf95324a07d05398b240174dc0c2be444d96b159aa6c7f7b1e668680991',
        '02edabbd16b41c8371b92ef2f04c1185b4f03b6dcd52ba9b78d9d7c89c8f221145',
      ]
    end
    let(:session_key) { '4141414141414141414141414141414141414141414141414141414141414141' }
    subject { described_class.compute_ephemereal_public_keys_and_shared_secrets(session_key, public_keys) }

    # hop_shared_secret[0] = 0x53eb63ea8a3fec3b3cd433b85cd62a4b145e1dda09391b348c4e1cd36a03ea66
    # hop_blinding_factor[0] = 0x2ec2e5da605776054187180343287683aa6a51b4b1c04d6dd49c45d8cffb3c36
    # hop_ephemeral_pubkey[0] = 0x02eec7245d6b7d2ccb30380bfbe2a3648cd7a942653f5aa340edcea1f283686619
    #
    # hop_shared_secret[1] = 0xa6519e98832a0b179f62123b3567c106db99ee37bef036e783263602f3488fae
    # hop_blinding_factor[1] = 0xbf66c28bc22e598cfd574a1931a2bafbca09163df2261e6d0056b2610dab938f
    # hop_ephemeral_pubkey[1] = 0x028f9438bfbf7feac2e108d677e3a82da596be706cc1cf342b75c7b7e22bf4e6e2
    #
    # hop_shared_secret[2] = 0x3a6b412548762f0dbccce5c7ae7bb8147d1caf9b5471c34120b30bc9c04891cc
    # hop_blinding_factor[2] = 0xa1f2dadd184eb1627049673f18c6325814384facdee5bfd935d9cb031a1698a5
    # hop_ephemeral_pubkey[2] = 0x03bfd8225241ea71cd0843db7709f4c222f62ff2d4516fd38b39914ab6b83e0da0
    #
    # hop_shared_secret[3] = 0x21e13c2d7cfe7e18836df50872466117a295783ab8aab0e7ecc8c725503ad02d
    # hop_blinding_factor[3] = 0x7cfe0b699f35525029ae0fa437c69d0f20f7ed4e3916133f9cacbb13c82ff262
    # hop_ephemeral_pubkey[3] = 0x031dde6926381289671300239ea8e57ffaf9bebd05b9a5b95beaf07af05cd43595
    #
    # hop_shared_secret[4] = 0xb5756b9b542727dbafc6765a49488b023a725d631af688fc031217e90770c328
    # hop_blinding_factor[4] = 0xc96e00dddaf57e7edcd4fb5954be5b65b09f17cb6d20651b4e90315be5779205
    # hop_ephemeral_pubkey[4] = 0x03a214ebd875aab6ddfd77f22c5e7311d7f77f17a169e599f157bbcdae8bf071f4
    it { expect(subject[0][0]).to eq '02eec7245d6b7d2ccb30380bfbe2a3648cd7a942653f5aa340edcea1f283686619' }
    it { expect(subject[1][0]).to eq '53eb63ea8a3fec3b3cd433b85cd62a4b145e1dda09391b348c4e1cd36a03ea66' }
    it { expect(subject[0][1]).to eq '028f9438bfbf7feac2e108d677e3a82da596be706cc1cf342b75c7b7e22bf4e6e2' }
    it { expect(subject[1][1]).to eq 'a6519e98832a0b179f62123b3567c106db99ee37bef036e783263602f3488fae' }
    it { expect(subject[0][2]).to eq '03bfd8225241ea71cd0843db7709f4c222f62ff2d4516fd38b39914ab6b83e0da0' }
    it { expect(subject[1][2]).to eq '3a6b412548762f0dbccce5c7ae7bb8147d1caf9b5471c34120b30bc9c04891cc' }
    it { expect(subject[0][3]).to eq '031dde6926381289671300239ea8e57ffaf9bebd05b9a5b95beaf07af05cd43595' }
    it { expect(subject[1][3]).to eq '21e13c2d7cfe7e18836df50872466117a295783ab8aab0e7ecc8c725503ad02d' }
    it { expect(subject[0][4]).to eq '03a214ebd875aab6ddfd77f22c5e7311d7f77f17a169e599f157bbcdae8bf071f4' }
    it { expect(subject[1][4]).to eq 'b5756b9b542727dbafc6765a49488b023a725d631af688fc031217e90770c328' }
  end
end
