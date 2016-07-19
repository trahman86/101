require 'pry'

# Tic Tac Toe is a 2 player game played on a 3x3 board. 
# Each player takes a turn and marks a square on the board.
# The first player to reach 3 squares in a row, including diagonals, wins.
# If all 9 squares are marked and no player has 3 squares in a row, then the game is a tie.

# 1. Display the initial empty 3x3 board.
# 2. Ask the user to mark a square.
# 3. Computer marks an available square.
# 4. Display the updated board.
# 5. If there's a winner, display the winner.
# 6. If board is full, display tie.
# 7. If there is no winner or a tie, go back to #2.
# 8. Ask if the player wants to play again.
# 9. If yes, go back to #1.
# 10. Say goodbye when they're done. 

INITIAL_MARKER = ' '
PLAYER_MARKER = 'X'
COMPUTER_MARKER = 'O'

def prompt(msg)
  puts " => #{msg}"
end

def display_board(brd)
  system 'clear'
  puts ""
  puts "     |     |"
  puts "  #{brd[1]}  |  #{brd[2]}  |  #{brd[3]}  "
  puts "     |     |"
  puts "-----+-----+------"
  puts "     |     |"
  puts "  #{brd[4]}  |  #{brd[5]}  |  #{brd[6]}  "
  puts "     |     |"
  puts "-----+-----+------"
  puts "     |     |"
  puts "  #{brd[7]}  |  #{brd[8]}  |  #{brd[9]}  "
  puts "     |     |"
end

def initialize_board
  new_board = {}
  (1..9).each {|num| new_board[num] = INITIAL_MARKER}
  new_board
end

def empty_squares(brd)
  brd.keys.select {|num| brd[num] == INITIAL_MARKER}
end


def player_places_piece!(brd)
  square = ''

  loop do
    prompt "Choose a square (#{empty_squares(brd).join(', ')}):"
    square = gets.chomp.to_i
    break if empty_squares(brd).include?(square)
    prompt "Sorry, that's not a valid choice."
  end

  brd[square] = PLAYER_MARKER
end

def computer_places_piece!(brd)
  square = empty_squares(brd).sample
  brd[square] = COMPUTER_MARKER
end

def board_full?(brd)
  empty_squares(brd).empty?
end

def someone_won?(brd)
  false
end

board = initialize_board
display_board(board)

loop do
  player_places_piece!(board)
  computer_places_piece!(board)
  puts board.inspect
  display_board(board)
  break if someone_won?(board) || board_full?(board)
end
display_board(board)
