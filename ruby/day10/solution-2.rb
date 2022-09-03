#!/usr/bin/env ruby
# frozen_string_literal: true

OPPOSITE_PARENS = {
  ')' => '(',
  ']' => '[',
  '}' => '{',
  '>' => '<'
}.freeze

ERROR_POINTS = {
  '(' => 1,
  '[' => 2,
  '{' => 3,
  '<' => 4
}.freeze

lines = File.read('input.txt').split("\n")

scores = []
lines.each do |line|
  stack = []
  corrupted = false
  line.each_char do |c|
    case c
    when '(', '[', '{', '<'
      stack.push(c)
    when ')', ']', '}', '>'
      if stack.pop != OPPOSITE_PARENS[c]
        corrupted = true
        break
      end
    end
  end
  next if corrupted

  score = 0
  until stack.empty?
    score = (score * 5) + ERROR_POINTS[stack.pop]
  end
  scores << score
end
i = scores.length / 2
puts scores.sort[i]
# 1190420163
