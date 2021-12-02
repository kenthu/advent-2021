#!/usr/bin/env ruby
# frozen_string_literal: true

input = File.read('day01-input.txt').split.map(&:to_i)
num_increase = 0
input.each_cons(4) do |a, b, c, d|
  num_increase += 1 if d > a
end
p num_increase

# Answer: 1518
