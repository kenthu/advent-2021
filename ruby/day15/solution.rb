#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

class Vertex
  attr_reader :x, :y, :distance_to_here
  attr_accessor :visited, :tentative_distance

  def initialize(x, y, distance_to_here)
    @x = x
    @y = y
    @distance_to_here = distance_to_here
    @visited = false
    @tentative_distance = Float::INFINITY
  end
end

# Find shortest path using Dijkstra's algorithm
class ShortestPath
  def initialize(input_filename, repeats)
    @unvisited = Set.new

    # Initially, each cell in @grid is just the distance to get to that cell
    @grid = File.read(input_filename).split("\n").map { |line| line.chars.map(&:to_i) }
    transform_grid if repeats
    @max_y = @grid.length - 1
    @max_x = @grid[0].length - 1

    # Convert each cell in @grid to a Vertex object
    (0..@max_y).each do |y|
      (0..@max_x).each do |x|
        @grid[y][x] = Vertex.new(x, y, @grid[y][x])
      end
    end
  end

  def transform_grid
    old_height = @grid.length
    old_width = @grid[0].length
    new_height = old_height * 5
    new_width = old_width * 5
    new_grid = Array.new(new_height) { Array.new(new_width) }

    (0...new_height).each do |y|
      (0...new_width).each do |x|
        orig_x = x % old_width
        orig_y = y % old_height
        base_value = @grid[orig_y][orig_x]
        increment_from_x = x / old_width
        increment_from_y = y / old_height
        final_value = base_value + increment_from_x + increment_from_y
        final_value -= 9 if final_value > 9
        new_grid[y][x] = final_value
      end
    end

    @grid = new_grid
  end

  def find_shortest_path
    # Start at top-left cell
    current = @grid[0][0]
    current.tentative_distance = 0
    @unvisited.add(current)

    until @grid[@max_y][@max_x].visited
      x = current.x
      y = current.y

      # Update tentative distances for unvisited neighbors
      unvisited_neighbors = []
      unvisited_neighbors << @grid[y][x + 1] if x + 1 <= @max_x && !@grid[y][x + 1].visited
      unvisited_neighbors << @grid[y][x - 1] if x - 1 >= 0 && !@grid[y][x - 1].visited
      unvisited_neighbors << @grid[y + 1][x] if y + 1 <= @max_y && !@grid[y + 1][x].visited
      unvisited_neighbors << @grid[y - 1][x] if y - 1 >= 0 && !@grid[y - 1][x].visited
      unvisited_neighbors.each do |neighbor|
        distance_to_neighbor_from_here = current.tentative_distance + neighbor.distance_to_here
        neighbor.tentative_distance = [neighbor.tentative_distance, distance_to_neighbor_from_here].min
        @unvisited.add(neighbor)
      end

      # Mark current cell visited
      current.visited = true
      @unvisited.delete(current)

      current = find_cell_smallest_tentative_distance
    end

    @grid[@max_y][@max_x].tentative_distance
  end

  # Takes O(n), where n is # of cells still unvisited. Could be faster with priority queue, but then
  # I'd have to implement that. Practically, it doesn't matter that much, since I'm optimizing by
  # only adding to the @unvisited set when I adjust tentative_distance for neighbors
  def find_cell_smallest_tentative_distance
    smallest_dist = Float::INFINITY
    vertex_with_smallest_dist = nil
    @unvisited.each do |vertex|
      if vertex.tentative_distance < smallest_dist
        smallest_dist = vertex.tentative_distance
        vertex_with_smallest_dist = vertex
      end
    end
    vertex_with_smallest_dist
  end
end

# Test
puts ShortestPath.new('test.txt', false).find_shortest_path
# 40

# Part 1
puts ShortestPath.new('input.txt', false).find_shortest_path
# 540

# Part 2
puts ShortestPath.new('input.txt', true).find_shortest_path
# 2879
