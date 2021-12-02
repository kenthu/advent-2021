#!/usr/bin/env ruby
# frozen_string_literal: true

input = File.read('day01-input.txt').split.map(&:to_i)
num_increase = 0
input.each_cons(2) do |x, y|
  num_increase += 1 if y > x
end
p num_increase

# Answer: 1482
