#!/usr/bin/env ruby
# frozen_string_literal: true

class SmokeModeler
  def initialize(height_map)
    @height_map = height_map
    @max_i = height_map.length - 1
    @max_j = height_map[0].length - 1
  end

  def find_answer
    low_points = find_low_points
    low_points.sum + low_points.length
  end

  def find_low_points
    low_points = []
    (0..@max_i).each do |i|
      (0..@max_j).each do |j|
        low_points << @height_map[i][j] if low_point?(i, j)
      end
    end
    low_points
  end

  def low_point?(i, j)
    # puts "(#{i}, #{j})"
    (i == 0 || @height_map[i][j] < @height_map[i-1][j]) &&
      (j == 0 || @height_map[i][j] < @height_map[i][j-1]) &&
      (i == @max_i || @height_map[i][j] < @height_map[i+1][j]) &&
      (j == @max_j || @height_map[i][j] < @height_map[i][j+1])
  end
end

height_map = File.read('input.txt').split("\n").map { |line| line.chars.map(&:to_i) }
puts SmokeModeler.new(height_map).find_answer
# 564