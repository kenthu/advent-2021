#!/usr/bin/env ruby
# frozen_string_literal: true

# 1000 lines, 12 bits each
numbers = File.read('input.txt').split

# Store in hash of hashes, where h[position][bit] is the count for that position & bit
counts = {}
num_bits = numbers[0].length
num_bits.times { |i| counts[i] = { '0' => 0, '1' => 0 } }

# Populate hash
numbers.each do |number|
  number.chars.each_with_index do |bit, i|
    counts[i][bit] += 1
  end
end

# Using most common bit
gamma_rate = ''
# Using least common bit
epsilon_rate = ''

num_bits.times do |position|
  gamma_rate += counts[position]['1'] > counts[position]['0'] ? '1' : '0'
  epsilon_rate += counts[position]['1'] > counts[position]['0'] ? '0' : '1'
end

puts gamma_rate.to_i(2) * epsilon_rate.to_i(2)
# 1071734
