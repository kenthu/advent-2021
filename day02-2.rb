#!/usr/bin/env ruby
# frozen_string_literal: true

input = File.read('day02-input.txt').split("\n")

horizontal_position = 0
depth = 0
aim = 0
input.each do |full_command|
  command, param = full_command.split
  param = param.to_i
  case command
  when 'down'
    aim += param
  when 'up'
    aim -= param
  when 'forward'
    horizontal_position += param
    depth += aim * param
  end
end
puts horizontal_position * depth

# Answer: 1963088820
