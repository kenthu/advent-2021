#!/usr/bin/env ruby
# frozen_string_literal: true

class Origami
  def initialize(input_filename)
    read_input(input_filename)

    @max_x = @dots.map { |x, _| x }.max
    @max_y = @dots.map { |_, y| y }.max
    @grid = Array.new(@max_y + 1) { Array.new(@max_x + 1, false) }
    @dots.each { |x, y| @grid[y][x] = true }
  end

  def read_input(input_filename)
    @dots = []
    @folds = []

    File.foreach(input_filename) do |line|
      case line
      when /^(\d+),(\d+)$/
        @dots << [$1.to_i, $2.to_i]
      when /^fold along ([xy])=(\d+)$/
        @folds << [$1.to_sym, $2.to_i]
      end
    end
  end

  # @param num_folds Integer number of folds to execute
  def execute_folds(num_folds=nil)
    folds_to_execute = num_folds ? @folds.take(num_folds) : @folds
    folds_to_execute.each do |axis, location|
      case axis
      when :x
        (0..@max_y).each do |y|
          (0..location - 1).each do |x|
            complement_x = (2 * location) - x
            @grid[y][x] = @grid[y][x] || @grid[y][complement_x] if complement_x <= @max_x
          end
        end
        @max_x = location - 1
      when :y
        (0..location - 1).each do |y|
          (0..@max_x).each do |x|
            complement_y = (2 * location) - y
            @grid[y][x] = @grid[y][x] || @grid[complement_y][x] if complement_y <= @max_y
          end
        end
        @max_y = location - 1
      else
        raise
      end
    end
  end

  def num_dots
    (0..@max_y).sum do |y|
      (0..@max_x).count { |x| @grid[y][x] }
    end
  end

  def draw_grid
    (0..@max_y).each do |y|
      (0..@max_x).each do |x|
        print @grid[y][x] ? '#' : '.'
      end
      puts ""
    end
    puts ""
  end
end

# Part 1
origami1 = Origami.new('input.txt')
origami1.execute_folds(1)
puts "Part 1: #{origami1.num_dots}"
# Answer: 666

# Part 2
origami2 = Origami.new('input.txt')
origami2.execute_folds
puts "Part 2:"
origami2.draw_grid
# Answer: CJHAZHKU
