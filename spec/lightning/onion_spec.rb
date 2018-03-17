# frozen_string_literal: true

require 'spec_helper'

describe Lightning::Onion do
  it 'has a version number' do
    expect(Lightning::Onion::VERSION).not_to be nil
  end
end
