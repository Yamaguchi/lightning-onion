# frozen_string_literal: true

module Lightning
  module Onion
    module ChaCha20
      autoload :OpenSSL, 'lightning/onion/chacha20/openssl'
      autoload :Pure, 'lightning/onion/chacha20/pure'

      def self.chacha20_encrypt(key, counter, nonce, plaintext)
        if ::OpenSSL::Cipher.ciphers.include?("ChaCha20")
          Lightning::Onion::ChaCha20::OpenSSL.chacha20_encrypt(key, counter, nonce, plaintext)
        else
          Lightning::Onion::ChaCha20::Pure.chacha20_encrypt(key, counter, nonce, plaintext)
        end
      end
    end
  end
end
