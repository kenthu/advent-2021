#!/usr/bin/env ruby
# frozen_string_literal: true

input = File.read('day02-input.txt').split("\n")

x = 0
depth = 0
input.each do |full_command|
  command, param = full_command.split
  param = param.to_i
  case command
  when 'forward'
    x += param
  when 'down'
    depth += param
  when 'up'
    depth -= param
  end
end
puts x * depth

# Answer: 1714680
