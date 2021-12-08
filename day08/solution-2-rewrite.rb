#!/usr/bin/env ruby
# frozen_string_literal: true

# Rewritten to copy this solution: https://www.reddit.com/r/adventofcode/comments/rbj87a/2021_day_8_solutions/hnoyy04/

require 'set'

total = 0
entries = File.read('input.txt').split("\n")
entries.each do |entry|
  signal_patterns, output = entry.split(' | ')

  # "4" is the only digit with four segments
  segments_for_digit_4 = signal_patterns.split.find { |pattern| pattern.length == 4 }.chars.to_set
  # "1" is the only digit with two segments
  segments_for_digit_1 = signal_patterns.split.find { |pattern| pattern.length == 2 }.chars.to_set

  decoded_number = ''
  output.split.each do |scrambled_digit|
    segments = scrambled_digit.chars.to_set
    overlap_with_digit_4 = (segments & segments_for_digit_4).size
    overlap_with_digit_1 = (segments & segments_for_digit_1).size
    decoded_number +=
      case [scrambled_digit.length, overlap_with_digit_4, overlap_with_digit_1]
      in [2, _, _] then '1'
      in [3, _, _] then '7'
      in [4, _, _] then '4'
      in [7, _, _] then '8'
      in [5, 2, _] then '2'
      in [5, 3, 1] then '5'
      in [5, 3, 2] then '3'
      in [6, 4, _] then '9'
      in [6, 3, 1] then '6'
      in [6, 3, 2] then '0'
      end
  end
  total += decoded_number.to_i
end
puts total
# 983026
