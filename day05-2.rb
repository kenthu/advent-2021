#!/usr/bin/env ruby
# frozen_string_literal: true

input = File.read('day05-input.txt').split("\n")

# Process input into segments array, filtering for horizontal and vertical segments
segments = []
input.each do |line|
  points = line.split(' -> ')
  x1, y1 = points[0].split(',').map(&:to_i)
  x2, y2 = points[1].split(',').map(&:to_i)
  segment = { x1: x1, y1: y1, x2: x2, y2: y2 }
  segments << segment
end

# Instantiate 1000x1000 grid
grid = Array.new(1000) { Array.new(1000, 0) }

# Paint grid using segments
segments.each do |segment|
  x_step = segment[:x2] - segment[:x1]
  x_step /= x_step.abs unless x_step.zero?

  y_step = segment[:y2] - segment[:y1]
  y_step /= y_step.abs unless y_step.zero?

  x, y = segment[:x1], segment[:y1]
  until x == segment[:x2] && y == segment[:y2]
    grid[x][y] += 1
    x += x_step
    y += y_step
  end
  grid[x][y] += 1
end

puts grid.map { |row| row.count { |num| num >= 2 } }.sum
# 19258
