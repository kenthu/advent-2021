#!/usr/bin/env ruby
# frozen_string_literal: true

# Approach:
# - Instead of tracking the actual string representing the polymer, just track the counts for each
#   pair. This will let us scale for many iterations

class Polymer
  def initialize(input_filename)
    input = File.read(input_filename).split("\n")

    # Process template (e.g., NNCB) into hash of consecutive pairs:
    # { 'NN' => 1, 'NC' => 1, 'CB' => 1 }
    template = input[0]
    @pair_counts = Hash.new(0)
    template.chars.each_cons(2) do |elem1, elem2|
      @pair_counts[elem1 + elem2] += 1
    end
    @last_letter = template[-1]

    # Process pair insertion rules
    @rules = {}
    pair_insertion_rules = input[2..]
    pair_insertion_rules.each do |rule|
      pair, inserted = rule.split(' -> ')
      raise if @rules.key?(pair)
      @rules[pair] = inserted
    end
  end

  # @param iterations Integer how many times we apply the rules
  def apply_rules(iterations)
    iterations.times do |n|
      # start_time = Time.now
      processed = Hash.new(0)
      @pair_counts.each do |pair, count|
        if @rules.key?(pair)
          new_elem = @rules[pair]
          processed[pair[0] + new_elem] += count
          processed[new_elem + pair[1]] += count
        else
          processed[pair] += count
        end
      end
      @pair_counts = processed
      # puts "After #{n + 1} iterations:"
      # puts "  Length is #{molecule.length}"
      # puts "  Last iteration took #{Time.now - start_time} seconds"
    end
    self
  end

  def score
    # Convert @pair_counts to @char_counts
    @char_counts = Hash.new(0)
    @pair_counts.each do |pair, count|
      # Only count the first letter of each pair
      @char_counts[pair[0]] += count
    end
    # Then add one to the last letter from template
    @char_counts[@last_letter] += 1

    counts = @char_counts.values.sort!
    counts.last - counts.first
  end
end

# Test
polymer = Polymer.new('test.txt')
puts polymer.apply_rules(10).score
# 1588

# Part 1
polymer = Polymer.new('input.txt')
puts polymer.apply_rules(10).score
# 2740

# Part 2
polymer = Polymer.new('input.txt')
puts polymer.apply_rules(40).score
# 2959788056211
