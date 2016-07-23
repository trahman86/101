require 'pry'

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

PLAY_MODE = 'choose'.freeze
INITIAL_MARKER = " ".freeze
PLAYER_MARKER = "X".freeze
COMPUTER_MARKER = "O".freeze
WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # row
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                [[1, 5, 9], [3, 5, 7]].freeze # diagonals

def prompt(msg)
  puts " => #{msg}"
end

def who_goes_first(pick)
  turn_choice = ''
  if pick == 'choose'
    loop do
      prompt "Type 1 to go first and 2 to go second"
      turn_choice = gets.chomp
      break if ["1", "2"].include?(turn_choice)
      prompt "Please choose either 1 or 2 for the order of your turn."
    end
  end
  if turn_choice == '1'
    'Player'
  else
    'Computer'
  end
end

# rubocop:disable Metrics/AbcSize
def display_board(brd, player_score, computer_score)
  system 'clear'
  puts "You're an #{PLAYER_MARKER}. Computer is a #{COMPUTER_MARKER}."
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
  prompt "The score is now Player: #{player_score} Computer: #{computer_score}"
end
# rubocop:enable Metrics/AbcSize

def initialize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = INITIAL_MARKER }
  new_board
end

def empty_squares(brd)
  brd.keys.select { |num| brd[num] == INITIAL_MARKER }
end

def joinor(brd, punctuation = ', ', conjunction = 'or')
  empties = empty_squares(brd)
  empties[-1] = "#{conjunction} #{empties.last}" if empties.size > 1
  empties.size == 2 ? empties.join(' ') : empties.join(punctuation)
end

def player_places_piece!(brd)
  square = ''

  loop do
    prompt "Choose a square (#{joinor(brd)}):"
    square = gets.chomp.to_i
    break if empty_squares(brd).include?(square)
    prompt "Sorry, that's not a valid choice."
  end

  brd[square] = PLAYER_MARKER
end

def find_square_to_block(line, brd)
  if brd.values_at(*line).count(PLAYER_MARKER) == 2
    brd.select { |key, value| line.include?(key) && value == ' ' }.keys.first
  end
end

def find_square_to_steal(line, brd)
  if brd.values_at(*line).count(COMPUTER_MARKER) == 2 &&
     brd.values_at(*line).count(PLAYER_MARKER) == 0
    brd.select { |key, value| line.include?(key) && value == ' ' }.keys.first
  end
end

def computer_places_piece!(brd)
  square = nil

  WINNING_LINES.each do |line|
    square = find_square_to_steal(line, brd)
    break if square
    square = find_square_to_block(line, brd)
    break if square
  end

  if square
    brd[square] = COMPUTER_MARKER
  elsif brd[5] == ' '
    square = 5
  else
    square = empty_squares(brd).sample
  end
  brd[square] = COMPUTER_MARKER
end

def place_piece!(brd, player)
  if player == 'Player'
    prompt "Your turn."
    player_places_piece!(brd)
  elsif player == 'Computer'
    computer_places_piece!(brd)
  end
end

def alternate_player(current_player)
  if current_player == 'Player'
    'Computer'
  else
    'Player'
  end
end

def board_full?(brd)
  empty_squares(brd).empty?
end

def someone_won?(brd)
  !!detect_winner(brd)
end

def detect_winner(brd)
  WINNING_LINES.each do |line|
    if brd.values_at(*line).count(PLAYER_MARKER) == 3
      return 'Player'
    elsif brd.values_at(*line).count(COMPUTER_MARKER) == 3
      return 'Computer'
    end
  end
  nil
end

def run_again?
  loop do
    prompt("Do you want to play again? Y for yes, N for no.")
    answer = gets.chomp.downcase
    break true if %w(y yes).include?(answer)
    break false if %w(n no).include?(answer)
    prompt("I didn't understand.")
  end
end

player_score = 0
computer_score = 0

loop do
  board = initialize_board
  current_player = who_goes_first(PLAY_MODE)
  # current_player.inspect
  loop do
    display_board(board, player_score, computer_score)
    place_piece!(board, current_player)
    current_player = alternate_player(current_player)
    break if someone_won?(board) || board_full?(board)
  end

  display_board(board, player_score, computer_score)

  if someone_won?(board)
    prompt"#{detect_winner(board)} won!"
  else
    prompt "It's a tie!"
  end

  # Update the scores at the end of the round
  if detect_winner(board) == 'Player'
    player_score += 1
  elsif detect_winner(board) == 'Computer'
    computer_score += 1
  else
    computer_score += 1
    player_score += 1
  end

  # Determine if someone has won 5 points (ties count as a point)
  if player_score == 5
    prompt("You won 5 points! Good game.")
    player_score = 0
    computer_score = 0
  elsif computer_score == 5
    prompt("The computer won 5 points! Good game.")
    player_score = 0
    computer_score = 0
  end
  break unless run_again?
end

prompt "Thanks for playing Tic Tac Toe! Goodbye."
