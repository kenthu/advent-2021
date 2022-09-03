#!/usr/bin/env ruby
# frozen_string_literal: true

input = File.read('input.txt').split("\n")

counter = 0

# Process inputs
input.each do |line|
  output = line.split(' | ')[1].split
  counter += output.count { |o| [2, 3, 4, 7].include?(o.length) }
end

puts counter
# 245
