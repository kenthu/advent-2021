#!/usr/bin/env ruby
# frozen_string_literal: true

BOARD_SIZE = 5

input = File.read('input.txt').split("\n")

# Read in drawn numbers
draws = input[0].split(',').map(&:to_i)
# Sanity check specific to my input
raise unless draws.first == 25 && draws.last == 67

# Read in boards
boards = []
input[2..].each_slice(BOARD_SIZE + 1) do |lines|
  board = []
  BOARD_SIZE.times { |i| board << lines[i].split.map(&:to_i) }
  boards << board
end
raise unless boards.length == 100 && boards.last.length == BOARD_SIZE

def handle_draw(draw, board)
  board.each do |line|
    line.each_with_index do |num, i|
      if draw == num
        line[i] = nil
        return draw * board_score(board) if board_complete?(board)
      end
    end
  end
  nil
end

def board_complete?(board)
  return true if (0...BOARD_SIZE).any? { |row| (0...BOARD_SIZE).all? { |col| board[row][col].nil? } }
  return true if (0...BOARD_SIZE).any? { |col| (0...BOARD_SIZE).all? { |row| board[row][col].nil? } }

  false
end

def board_score(board)
  board.map { |line| line.compact.sum }.sum
end

draws.each do |draw|
  boards.each do |board|
    final_score = handle_draw(draw, board)
    unless final_score.nil?
      puts "Final score: #{final_score}"
      exit
    end
  end
end
# 50008
