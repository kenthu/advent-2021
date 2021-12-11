#!/usr/bin/env ruby
# frozen_string_literal: true

OPPOSITE_PARENS = {
  ')' => '(',
  ']' => '[',
  '}' => '{',
  '>' => '<',
}.freeze

ERROR_POINTS = {
  ')' => 3,
  ']' => 57,
  '}' => 1197,
  '>' => 25137,
}.freeze

lines = File.read('input.txt').split("\n")

score = 0

lines.each do |line|
  stack = []
  line.each_char do |c|
    case c
    when '(', '[', '{', '<'
      stack.push(c)
    when ')', ']', '}', '>'
      unless stack.pop == OPPOSITE_PARENS[c]
        score += ERROR_POINTS[c]
        break
      end
    end
  end
end
puts score
# 