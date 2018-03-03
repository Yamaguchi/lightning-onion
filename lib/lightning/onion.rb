# frozen_string_literal: true

require 'lightning/onion/version'

require 'rbnacl'
require 'bitcoin'

module Lightning
  module Onion
    autoload :HopData, 'lightning/onion/hop_data'
    autoload :PerHop, 'lightning/onion/per_hop'
    autoload :Packet, 'lightning/onion/packet'
    autoload :Sphinx, 'lightning/onion/sphinx'
  end
end
