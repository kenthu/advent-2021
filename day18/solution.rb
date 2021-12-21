#!/usr/bin/env ruby
# frozen_string_literal: true

require 'rspec/autorun'

class Node; end

class Pair < Node
  attr_accessor :left, :right

  def initialize(left, right)
    @left = left
    @right = right
  end

  # @param number_string String either a bracketed snailfish number or a regular number
  #   [[[[4,3],4],4],[7,[[8,4],9]]]
  #   5
  # @return Node
  def self.from_string(number_string)
    return Leaf.new(number_string.to_i) if number_string =~ /^[0-9]+$/
    left_string, right_string = break_up(number_string)
    Pair.new(
      from_string(left_string),
      from_string(right_string)
    )
  end

  # Break up snailfish number as string, into two strings, representing left and right values
  # @param number_string String snailfish number as string
  # @return [String, String]
  def self.break_up(number_string)
    depth = 0
    number_string.chars.each_with_index do |c, i|
      if c == '['
        depth += 1
      elsif c == ']'
        depth -= 1
      elsif c == ',' && depth == 1
        left = number_string[1...i]
        right = number_string[i + 1...-1]
        return [left, right]
      end
    end
    raise
  end

  def +(other)
    sum = Pair.new(self, other)
    # Run apply_reduction until it returns false
    while sum.apply_reduction; end
    sum
  end

  def base_pair?
    @left.is_a?(Leaf) && @right.is_a?(Leaf)
  end

  def to_s
    "[#{@left},#{@right}]"
  end

  # Apply one reduction step. Run a depth-first traversal
  # @return Boolean true iff reduction applied
  def apply_reduction
    @last_leaf = nil
    @next_action = nil
    catch(:reduction_applied) { reduction_helper(self, 0, :explosion) }
    reduction_applied = @next_action == :explosion_done || @next_action == :explode3
    return true if reduction_applied

    catch(:reduction_applied) { reduction_helper(self, 0, :split) }
    reduction_applied = @next_action == :split_done
    reduction_applied
  end

  def magnitude
    magnitude_helper(self)
  end

  private

  def magnitude_helper(node)
    return node.value if node.is_a?(Leaf)
    (3 * magnitude_helper(node.left)) + (2 * magnitude_helper(node.right))
  end

  # @param node Node
  # @param depth Integer
  # @param mode Symbol the reduction we're searching for, either :explosion or :split
  def reduction_helper(node, depth, mode)
    if node.is_a?(Leaf)
      # Explode, part 3: the pair's right value is added to the first regular number to the right of
      # the exploding pair (if any)
      if @next_action == :explode3
        node.value += @explode_right
        @next_action = :explosion_done
        throw :reduction_applied
      end

      @next_action = :split if mode == :split && node.value >= 10

      # Keep track of last leaf (i.e., regular number), so we can easily add to it when exploding
      @last_leaf = node
      return
    end

    if mode == :explosion && !@next_action && depth >= 4 && node.base_pair?
      @explode_left = node.left.value
      @explode_right = node.right.value

      # Explode, part 1: the pair's left value is added to the first regular number to the left of
      # the exploding pair (if any)
      @last_leaf.value += @explode_left if @last_leaf

      @next_action = :explode2
      return
    end

    # Recurse into children
    [:left, :right].each do |side|
      child = side == :left ? node.left : node.right
      reduction_helper(child, depth + 1, mode)

      # Handle any resulting actions
      case @next_action
      when :explode2
        # Explode, part 2: the entire exploding pair is replaced with the regular number 0.
        case side
        when :left then node.left = Leaf.new(0)
        when :right then node.right = Leaf.new(0)
        end
        @next_action = :explode3
      when :split
        case side
        when :left then node.left = node.left.split
        when :right then node.right = node.right.split
        end
        @next_action = :split_done
        throw :reduction_applied
      end
    end
  end
end

class Leaf < Node
  attr_accessor :value

  def initialize(value)
    @value = value
  end

  def split
    new_left = @value / 2
    new_right = @value - new_left
    Pair.new(Leaf.new(new_left), Leaf.new(new_right))
  end

  def to_s
    @value.to_s
  end
end

class SnailfishMath
  def initialize(input_filename)
    @number_strings = File.read(input_filename).split("\n")
  end

  def combine_all
    @number_strings.map { |line| Pair.from_string(line) }.reduce(:+)
  end

  def find_max_magnitude
    max_magnitude = -Float::INFINITY
    @number_strings.each_with_index do |number_string1, i|
      @number_strings.each_with_index do |number_string2, j|
        next if i == j
        magnitude = (Pair.from_string(number_string1) + Pair.from_string(number_string2)).magnitude
        max_magnitude = magnitude if magnitude > max_magnitude
      end
    end
    max_magnitude
  end
end

RSpec.describe SnailfishMath do
  it 'handles provided examples' do
    expect(SnailfishMath.new('test1.txt').combine_all.to_s).to eq('[[[[0,7],4],[[7,8],[6,0]]],[8,1]]')
    expect(SnailfishMath.new('test2.txt').combine_all.to_s).to eq('[[[[1,1],[2,2]],[3,3]],[4,4]]')
    expect(SnailfishMath.new('test3.txt').combine_all.to_s).to eq('[[[[3,0],[5,3]],[4,4]],[5,5]]')
    expect(SnailfishMath.new('test4.txt').combine_all.to_s).to eq('[[[[5,0],[7,4]],[5,5]],[6,6]]')
    expect(SnailfishMath.new('test5.txt').combine_all.to_s).to eq('[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]')
    expect(SnailfishMath.new('test6.txt').combine_all.to_s).to eq('[[[[6,6],[7,6]],[[7,7],[7,0]]],[[[7,7],[7,7]],[[7,8],[9,9]]]]')

    expect(Pair.from_string('[[1,2],[[3,4],5]]').magnitude).to be(143)
    expect(Pair.from_string('[[[[0,7],4],[[7,8],[6,0]]],[8,1]]').magnitude).to be(1384)
    expect(Pair.from_string('[[[[1,1],[2,2]],[3,3]],[4,4]]').magnitude).to be(445)
    expect(Pair.from_string('[[[[3,0],[5,3]],[4,4]],[5,5]]').magnitude).to be(791)
    expect(Pair.from_string('[[[[5,0],[7,4]],[5,5]],[6,6]]').magnitude).to be(1137)
    expect(Pair.from_string('[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]').magnitude).to be(3488)
    expect(Pair.from_string('[[[[6,6],[7,6]],[[7,7],[7,0]]],[[[7,7],[7,7]],[[7,8],[9,9]]]]').magnitude).to be(4140)

    expect(SnailfishMath.new('test6.txt').find_max_magnitude).to be(3993)
  end

  # Part 1
  it 'handles part 1' do
    expect(SnailfishMath.new('input.txt').combine_all.magnitude).to be(2501)
  end

  # Part 2
  it 'handles part 2' do
    expect(SnailfishMath.new('input.txt').find_max_magnitude).to be(4935)
  end
end
