#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

input = File.read('input.txt').split("\n")

def process_input(input)
  entries = []
  input.each do |line|
    # Example for `line`:
    # badf gadfec bgcad ad dbcfg gcaeb fecdgab gad bgcadf efcdgb | gcadb ad agd deacfg
    signal_patterns, output = line.split(' | ')
    entries << [signal_patterns.split, output.split]
  end
  entries
end

# Manual frequency analysis of valid segments
# Segment a appears in 8 numbers
# Segment b appears in 6 numbers
# Segment c appears in 8 numbers
# Segment d appears in 7 numbers
# Segment e appears in 4 numbers (0, 2, 6, and 8)
# Segment f appears in 9 numbers
# Segment g appears in 7 numbers

# Build encoder hash that maps intended segment to actual segment displayed
def encoder_hash(signal_patterns)
  # Start frequency analysis of encoded patterns. Map each segment to how many times we see it in
  # signal_patterns
  freq = Hash.new(0)
  signal_patterns.join.each_char { |c| freq[c] += 1 }

  encoder = {}
  # 1. Segment e appears in 4 numbers
  encoder['e'] = freq.key(4)
  # 2. Segment b appears in 6 numbers
  encoder['b'] = freq.key(6)
  # 3. Segment f appears in 9 numbers
  encoder['f'] = freq.key(9)

  # 4. Segment a is the extra one when comparing the 3-segment digit (7) and the 2-segment digit (1)
  #    7:       1:
  #   aaaa     ....
  #  .    c   .    c
  #  .    c   .    c
  #   ....  -  ....
  #  .    f   .    f
  #  .    f   .    f
  #   ....     ....
  segments_for_7 = signal_patterns.find { |p| p.length == 3 }.chars.to_set
  segments_for_1 = signal_patterns.find { |p| p.length == 2 }.chars.to_set
  encoder['a'] = (segments_for_7 - segments_for_1).first

  # 5. Segment c is the other segment that appears 8 times (not a)
  encoder['c'] = freq.find { |k, v| v == 8 && k != encoder['a'] }[0]

  # 6. Segment d is the segment that's in the 4-segment digit but is not b, c, or f
  segments_for_4 = signal_patterns.find { |p| p.length == 4 }.chars.to_set
  encoder['d'] = segments_for_4.delete(encoder['b']).delete(encoder['c']).delete(encoder['f']).first

  # 7. Segment g is the remaining segment
  encoder['g'] = (Set['a', 'b', 'c', 'd', 'e', 'f', 'g'] - encoder.values).first

  encoder
end

# Build decoder hash, that maps segment strings to digits
def decoder_hash(encoder)
  decoder = {}
  # 0 is normally comprised of segments abcefg, so let's encode those, then map that encoded value back to '0'
  decoder[[encoder['a'], encoder['b'], encoder['c'],               encoder['e'], encoder['f'], encoder['g']].sort.join] = '0'
  decoder[[                            encoder['c'],                             encoder['f']              ].sort.join] = '1'
  decoder[[encoder['a'],               encoder['c'], encoder['d'], encoder['e'],               encoder['g']].sort.join] = '2'
  decoder[[encoder['a'],               encoder['c'], encoder['d'],               encoder['f'], encoder['g']].sort.join] = '3'
  decoder[[              encoder['b'], encoder['c'], encoder['d'],               encoder['f']              ].sort.join] = '4'
  decoder[[encoder['a'], encoder['b'],               encoder['d'],               encoder['f'], encoder['g']].sort.join] = '5'
  decoder[[encoder['a'], encoder['b'],               encoder['d'], encoder['e'], encoder['f'], encoder['g']].sort.join] = '6'
  decoder[[encoder['a'],               encoder['c'],                             encoder['f']              ].sort.join] = '7'
  decoder[[encoder['a'], encoder['b'], encoder['c'], encoder['d'], encoder['e'], encoder['f'], encoder['g']].sort.join] = '8'
  decoder[[encoder['a'], encoder['b'], encoder['c'], encoder['d'],               encoder['f'], encoder['g']].sort.join] = '9'
  decoder
end

# @return Integer decoded value
def decode_entry(entry)
  signal_patterns, output = entry

  # Examples
  # signal_patterns: ['badf', 'gadfec', 'bgcad', 'ad', 'dbcfg', 'gcaeb', 'fecdgab', 'gad', 'bgcadf', 'efcdgb']
  # output: ['gcadb', 'ad', 'agd', 'deacfg']

  encoder = encoder_hash(signal_patterns)
  decoder = decoder_hash(encoder)
  decoded_number = output.map { |encoded_digit| decoder[encoded_digit.chars.sort.join] }.join
  decoded_number.to_i
end

entries = process_input(input)
puts entries.map { |entry| decode_entry(entry) }.sum
# 983026
