#!/usr/bin/env ruby
# frozen_string_literal: true

BOARD_SIZE = 5

input = File.read('day04-input.txt').split("\n")

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

# @return Boolean whether or not the board was completed
def handle_draw(draw, board)
  board.each do |line|
    line.each_with_index do |num, i|
      if draw == num
        line[i] = nil
        return true if board_complete?(board)
      end
    end
  end
  false
end

def board_complete?(board)
  return true if (0...BOARD_SIZE).any? { |row| (0...BOARD_SIZE).all? { |col| board[row][col].nil? } }
  return true if (0...BOARD_SIZE).any? { |col| (0...BOARD_SIZE).all? { |row| board[row][col].nil? } }

  false
end

def board_score(board)
  board.map { |line| line.compact.sum }.sum
end

last_to_win = nil
draws.each do |draw|
  boards.delete_if do |board|
    if handle_draw(draw, board)
      last_to_win = board
      true
    else
      false
    end
  end
  if boards.empty?
    puts "Final score: #{draw * board_score(last_to_win)}"
    exit
  end
end
# 17408
