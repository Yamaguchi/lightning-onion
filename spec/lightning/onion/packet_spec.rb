# frozen_string_literal: true

require 'spec_helper'

describe Lightning::Onion::Packet do
  describe '.last?' do
    let(:private_keys) do
      [
        '4141414141414141414141414141414141414141414141414141414141414141',
        '4242424242424242424242424242424242424242424242424242424242424242',
        '4343434343434343434343434343434343434343434343434343434343434343',
        '4444444444444444444444444444444444444444444444444444444444444444',
        '4545454545454545454545454545454545454545454545454545454545454545'
      ]
    end
    let(:public_keys) do
      [
        '02eec7245d6b7d2ccb30380bfbe2a3648cd7a942653f5aa340edcea1f283686619',
        '0324653eac434488002cc06bbfb7f10fe18991e35f9fe4302dbea6d2353dc0ab1c',
        '027f31ebc5462c1fdce1b737ecff52d37d75dea43ce11c74d25aa297165faa2007',
        '032c0b7cf95324a07d05398b240174dc0c2be444d96b159aa6c7f7b1e668680991',
        '02edabbd16b41c8371b92ef2f04c1185b4f03b6dcd52ba9b78d9d7c89c8f221145'
      ]
    end
    let(:session_key) { '4141414141414141414141414141414141414141414141414141414141414141' }
    let(:payloads) do
      [
        '000000000000000000000000000000000000000000000000000000000000000000',
        '000101010101010101000000000000000100000001000000000000000000000000',
        '000202020202020202000000000000000200000002000000000000000000000000',
        '000303030303030303000000000000000300000003000000000000000000000000',
        '000404040404040404000000000000000400000004000000000000000000000000'
      ]
    end
    let(:associated_data) { '4242424242424242424242424242424242424242424242424242424242424242' }
    let(:packet) { Lightning::Onion::Sphinx.make_packet(session_key, public_keys, payloads, associated_data) }
    it 'parse onion packet correctly' do
      _, next_packet0, = Lightning::Onion::Sphinx.parse(private_keys[0], packet[0].to_payload)
      _, next_packet1, = Lightning::Onion::Sphinx.parse(private_keys[1], next_packet0.to_payload)
      _, next_packet2, = Lightning::Onion::Sphinx.parse(private_keys[2], next_packet1.to_payload)
      _, next_packet3, = Lightning::Onion::Sphinx.parse(private_keys[3], next_packet2.to_payload)
      _, next_packet4, = Lightning::Onion::Sphinx.parse(private_keys[4], next_packet3.to_payload)

      packets = [next_packet0, next_packet1, next_packet2, next_packet3, next_packet4]
      expect(packets[0].last?).to be_falsy
      expect(packets[1].last?).to be_falsy
      expect(packets[2].last?).to be_falsy
      expect(packets[3].last?).to be_falsy
      expect(packets[4].last?).to be_truthy
    end
  end
end