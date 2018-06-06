# frozen_string_literal: true

require 'spec_helper'

describe Lightning::Onion::HopData do
  describe '.parse' do
    let(:payload) do
      '0000000000000000000000000000000000000000000000000000000000000000' \
      '0000000000000000000000000000000000000000000000000000000000000000' \
      '00'.htb
    end

    subject { described_class.parse(payload) }
    it { expect(subject.realm).to eq 0 }
    it { expect(subject.per_hop.short_channel_id).to eq 0 }
    it { expect(subject.per_hop.amt_to_forward).to eq 0 }
    it { expect(subject.per_hop.outgoing_cltv_value).to eq 0 }
    it { expect(subject.per_hop.padding).to eq "\x00" * 12 }
    it { expect(subject.hmac).to eq "\x00" * 32 }
  end
end
