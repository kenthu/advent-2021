#!/usr/bin/env ruby
# frozen_string_literal: true

# 1000 lines, 12 bits each
numbers = File.read('day03-input.txt').split

def find_rating(numbers, bit_selector)
  num_bits = numbers[0].length
  num_bits.times do |position|
    break if numbers.length <= 1

    counts = { '0' => 0, '1' => 0 }
    numbers.each { |number| counts[number[position]] += 1 }

    bit_filter =
      if counts['1'] >= counts['0']
        bit_selector == :most_common ? '1' : '0'
      else
        bit_selector == :most_common ? '0' : '1'
      end

    numbers.select! { |num| num[position] == bit_filter }
  end
  numbers.first.to_i(2)
end

oxy_rating = find_rating(numbers.dup, :most_common)
co2_rating = find_rating(numbers.dup, :least_common)

puts oxy_rating * co2_rating
# 6124992
