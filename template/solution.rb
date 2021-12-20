#!/usr/bin/env ruby
# frozen_string_literal: true

class Foo
  def initialize(input_filename)
    input = File.read(input_filename).split("\n")
  end
end

# Test
foo = Foo.new('test.txt')

# Part 1
foo = Foo.new('input.txt')

# Part 2
foo = Foo.new('input.txt')
