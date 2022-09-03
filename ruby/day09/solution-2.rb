#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

class SmokeModeler
  def initialize(height_map)
    @height_map = height_map
    @max_i = height_map.length - 1
    @max_j = height_map[0].length - 1
  end

  def find_answer
    basin_sizes = []
    (0..@max_i).each do |i|
      (0..@max_j).each do |j|
        basin_sizes << explore_basin(i, j) if @height_map[i][j] != 9
      end
    end
    basin_sizes.sort.last(3).reduce(&:*)
  end

  # Return size of explored basin
  # Mutates @height_map by setting it to 9 as locations are visited
  def explore_basin(i, j)
    basin_size = 0
    # Set of pairs to be explored. Use a set instead of array for automatic deduplication. We never
    # want to visit a location twice, and we rely on unvisited_neighbors to check if already
    # visited.
    explore_queue = Set[[i, j]]
    until explore_queue.empty?
      i, j = explore_queue.first
      explore_queue.delete([i, j])
      basin_size += 1
      # Mark as visited
      @height_map[i][j] = 9
      explore_queue += unvisited_neighbors(i, j)
    end
    basin_size
  end

  def unvisited_neighbors(i, j)
    neighbors = Set.new
    neighbors.add([i - 1, j]) if i > 0 && @height_map[i - 1][j] != 9
    neighbors.add([i, j - 1]) if j > 0 && @height_map[i][j - 1] != 9
    neighbors.add([i + 1, j]) if i < @max_i && @height_map[i + 1][j] != 9
    neighbors.add([i, j + 1]) if j < @max_j && @height_map[i][j + 1] != 9
    neighbors
  end
end

height_map = File.read('input.txt').split("\n").map { |line| line.chars.map(&:to_i) }
puts SmokeModeler.new(height_map).find_answer
# 1038240
