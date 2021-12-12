#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

edges = File.read('input.txt').split("\n")

class Vertex
  attr_reader :id, :neighbors

  def initialize(id)
    @id = id
    @neighbors = Set.new
  end

  def add_neighbor(neighbor)
    @neighbors.add(neighbor)
  end

  def small?
    /^[a-z]+$/.match(id)
  end
end

class Graph
  def initialize(edges)
    @vertices = {}
    edges.each do |edge|
      vertex_pair = edge.split('-')
      add_vertex(vertex_pair[0])
      add_vertex(vertex_pair[1])
      add_edge(vertex_pair[0], vertex_pair[1])
    end
  end

  def add_vertex(id)
    @vertices[id] = Vertex.new(id) unless @vertices.key?(id)
  end

  def add_edge(id1, id2)
    v1 = @vertices[id1]
    v2 = @vertices[id2]
    v1.add_neighbor(v2)
    v2.add_neighbor(v1)
  end

  # @return Set<String> set of paths
  def find_paths(allow_a_double_visit)
    find_paths_helper(@vertices['start'], '', Set.new, !allow_a_double_visit)
  end

  def find_paths_helper(current_cave, path, small_caves_visited, used_double_visit)
    return 1 if current_cave.id == 'end'

    num_paths = 0
    current_cave.neighbors.each do |neighbor|
      next if neighbor.id == 'start'

      if small_caves_visited.include?(neighbor)
        num_paths += find_paths_helper(neighbor, path, small_caves_visited, true) unless used_double_visit
        next
      end

      small_caves_visited.add(neighbor) if neighbor.small?
      num_paths += find_paths_helper(neighbor, path, small_caves_visited, used_double_visit)
      small_caves_visited.delete(neighbor)
    end
    num_paths
  end
end

pp Graph.new(edges).find_paths(true)
# 131254
