# frozen_string_literal: true

module Lightning
  module Onion
    module ChaCha20
      def self.constants
        [0x61707865, 0x3320646e, 0x79622d32, 0x6b206574].pack('N*')
      end

      def self.chacha20_encrypt(key, counter, nonce, plaintext)
        encrypted_message = +''
        (plaintext.length / 64).times do |i|
          key_stream = chacha20_block(key, counter + i, nonce)
          block = plaintext[(i * 64)...(i + 1) * 64]
          encrypted_message += xor(block, key_stream)
        end
        if plaintext.length % 64 != 0
          i = plaintext.length / 64
          key_stream = chacha20_block(key, counter + i, nonce)
          block = plaintext[(i * 64)...plaintext.length]
          block = block.ljust(64, "\x00")
          encrypted_message += xor(block, key_stream)[0...(plaintext.length % 64)]
        end
        encrypted_message
      end

      def self.xor(a, b)
        a = a.unpack('N*')
        b = b.unpack('N*')
        a.zip(b).map { |x, y| (x ^ y) & 0xffffffff }.pack('N*')
      end

      # key: 32 bytes
      # counter: integer (4 bytes)
      # nonce: 12 bytes
      def self.chacha20_block(key, counter, nonce)
        # reverse order
        key = key.unpack('V*').pack('N*')
        counter = [counter].pack('N*')
        nonce = nonce.unpack('V*').pack('N*')
        state = constants + key + counter + nonce
        working_state = state.unpack('N*')
        10.times do
          inner_block(working_state)
        end
        plus_for_string(state, working_state)
      end

      def self.inner_block(x)
        # column rounds
        x[0], x[4], x[8], x[12] = quater_round(x[0], x[4], x[8], x[12])
        x[1], x[5], x[9], x[13] = quater_round(x[1], x[5], x[9], x[13])
        x[2], x[6], x[10], x[14] = quater_round(x[2], x[6], x[10], x[14])
        x[3], x[7], x[11], x[15] = quater_round(x[3], x[7], x[11], x[15])
        # diagonal rounds
        x[0], x[5], x[10], x[15] = quater_round(x[0], x[5], x[10], x[15])
        x[1], x[6], x[11], x[12] = quater_round(x[1], x[6], x[11], x[12])
        x[2], x[7], x[8], x[13] = quater_round(x[2], x[7], x[8], x[13])
        x[3], x[4], x[9], x[14] = quater_round(x[3], x[4], x[9], x[14])
      end

      def self.plus_for_string(a, b)
        a.unpack('N*').map.with_index do |x, i|
          plus(x, b[i])
        end.pack('V*')
      end

      def self.plus(x, y)
        (x + y) & 0xffffffff
      end

      def self.rotate(x, n)
        y = x << n
        z = x >> (32 - n)
        (y | z) & 0xffffffff
      end

      def self.quater_round(a, b, c, d)
        a = plus(a, b)
        d ^= a
        d = rotate(d, 16)

        c = plus(c, d)
        b ^= c
        b = rotate(b, 12)

        a = plus(a, b)
        d ^= a
        d = rotate(d, 8)

        c = plus(c, d)
        b ^= c
        b = rotate(b, 7)
        [a, b, c, d]
      end
    end
  end
end
