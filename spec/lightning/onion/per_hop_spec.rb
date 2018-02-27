# frozen_string_literal: true

require 'spec_helper'

describe Lightning::Onion::PerHop do
  describe '.parse' do
    let(:payload) { '000000000000000000000000000000000000000000000000000000000000000000'.htb }
    subject { described_class.parse(payload) }
    it { expect(subject.channel_id).to eq "\x00" * 8 }
    it { expect(subject.amt_to_forward).to eq 0 }
    it { expect(subject.outgoing_cltv_value).to eq 0 }
    it { expect(subject.padding).to eq "\x00" * 16 }
  end
end
