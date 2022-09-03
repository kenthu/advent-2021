#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

input = File.read('input.txt').split("\n").map { |line| line.chars.map(&:to_i) }

def execute_steps(energies, num_steps)
  flashes = 0
  grid_length = energies.length
  num_steps.times do |_|
    # Increase energy level for all octopi
    (0...grid_length).each do |i|
      (0...grid_length).each do |j|
        # puts "#{i}, #{j}"
        energies[i][j] += 1
      end
    end

    flashed = Set.new
    loop do
      found_flashers = false
      (0...grid_length).each do |i|
        (0...grid_length).each do |j|
          if energies[i][j] > 9 && !flashed.include?([i, j])
            increment_neighbors(energies, i, j)
            flashes += 1
            flashed.add([i, j])
            found_flashers = true
          end
        end
      end
      break unless found_flashers
    end

    flashed.each do |i, j|
      energies[i][j] = 0
    end
  end

  puts flashes
end

def increment_neighbors(energies, i, j)
  energies[i - 1][j - 1] += 1 if i > 0 && j > 0
  energies[i - 1][j]     += 1 if i > 0
  energies[i - 1][j + 1] += 1 if i > 0 && j < energies.length - 1
  energies[i][j - 1]     += 1 if j > 0
  energies[i][j + 1]     += 1 if j < energies.length - 1
  energies[i + 1][j - 1] += 1 if i < energies.length - 1 && j > 0
  energies[i + 1][j]     += 1 if i < energies.length - 1
  energies[i + 1][j + 1] += 1 if i < energies.length - 1 && j < energies.length - 1
end

execute_steps(input, 100)
# 1617