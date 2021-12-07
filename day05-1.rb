#!/usr/bin/env ruby
# frozen_string_literal: true

input = File.read('day05-input.txt').split("\n")

def horizontal?(segment)
  segment[:y1] == segment[:y2]
end

def vertical?(segment)
  segment[:x1] == segment[:x2]
end

# Process input into segments array, filtering for horizontal and vertical segments
segments = []
input.each do |line|
  points = line.split(' -> ')
  x1, y1 = points[0].split(',').map(&:to_i)
  x2, y2 = points[1].split(',').map(&:to_i)
  segment = { x1: x1, y1: y1, x2: x2, y2: y2 }
  segments << segment if horizontal?(segment) || vertical?(segment)
end

# Instantiate 1000x1000 grid
grid = Array.new(1000) { Array.new(1000, 0) }

# Paint grid using segments
segments.each do |segment|
  if horizontal?(segment)
    # e.g., (0, 7) => (9, 7)
    min, max = [segment[:x1], segment[:x2]].sort
    (min..max).each { |x| grid[x][segment[:y1]] += 1 }
  else
    # e.g., (7, 9) => (7, 2)
    min, max = [segment[:y1], segment[:y2]].sort
    (min..max).each { |y| grid[segment[:x1]][y] += 1 }
  end
end

puts grid.map { |row| row.count { |num| num >= 2} }.sum
# 6841
