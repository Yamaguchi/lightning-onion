# frozen_string_literal: true

module Lightning
  module Onion
    module ChaCha20
      class OpenSSL
        def self.chacha20_encrypt(key, counter, nonce, plaintext)
          cipher = ::OpenSSL::Cipher.new("ChaCha20")
          cipher.encrypt
          cipher.iv = [counter].pack('V*') + nonce
          cipher.key = key
          cipher.update(plaintext) + cipher.final
        end
      end
    end
  end
end
