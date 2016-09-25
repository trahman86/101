require 'pry'

SUITS = ['Hearts', 'Diamonds', 'Spades', 'Clubs'].freeze
VALUES = ['2', '3', '4,', '5', '6', '7', '8', '9', '10', 'Jack',
          'Queen', 'King', 'Ace'].freeze
BUST_VALUE = 21

def prompt(msg)
  puts "=> #{msg}"
end

def initialize_deck
  # this creates a shuffled deck of cards as a nested array
  SUITS.product(VALUES).shuffle
end

def total(cards)
  # card = [['H', '3'], ['S', 'Q'], ... ]
  # for each, value is taken from the 2nd spot in the inside array
  values = cards.map { |card| card[1] }

  sum = 0
  values.each do |value|
    sum += value.to_i
    sum += 11 if value == "Ace"
    sum += 10 if value.to_i == 0 # J, Q, K
  end

  # correct for Aces
  values.select { |value| value == "Ace" }.count.times do
    sum -= 10 if sum > BUST_VALUE
  end

  sum
end

def busted?(cards)
  total(cards) > BUST_VALUE
end

# :tie, :dealer, :player, : dealer_busted, :player_busted
def detect_result(d_total, p_total)
  if p_total > BUST_VALUE
    :player_busted
  elsif d_total > BUST_VALUE
    :dealer_busted
  elsif d_total < p_total
    :player_wins
  elsif d_total > p_total
    :dealer_wins
  else
    :tie
  end
end

def update_match_score(result, d_matches_won, p_matches_won)
  case result
  when :player_busted, :dealer_wins
    d_matches_won << 1
  when :dealer_busted, :player_wins
    p_matches_won << 1
  end
end

def display_result(d_total, p_total, d_matches_won, p_matches_won)
  result = detect_result(d_total, p_total)
  update_match_score(result, d_matches_won, p_matches_won)

  case result
  when :player_busted
    prompt "You busted! Dealer wins!"
  when :dealer_busted
    prompt "Dealer busted! You win!"
  when :player_wins
    prompt "You win!"
  when :dealer_wins
    prompt "Dealer wins!"
  when :tie
    prompt "It's a tie!"
  end
end

def detect_match_result(d_matches_won, p_matches_won)
  if d_matches_won.length < 5 && p_matches_won.length < 5
    :no_winner
  elsif d_matches_won.length == 5 && p_matches_won.length < 5
    :dealer_match
  else
    :player_match
  end
end

def match_won(d_total, p_total, d_matches_won, p_matches_won)
  display_result(d_total, p_total, d_matches_won, p_matches_won)
  match = detect_match_result(d_matches_won, p_matches_won)
  case match
  when :no_winner
    prompt "Dealer has won #{d_matches_won.length} hands.
    You've won #{p_matches_won.length} hands."
  when :dealer_match
    prompt "Game over. Dealer wins the game!"
    d_matches_won.delete(1)
    p_matches_won.delete(1)
  when :player_match
    prompt "Game over. Player wins the game!"
    d_matches_won.delete(1)
    p_matches_won.delete(1)
  end
end

def play_again?
  puts "------------"
  prompt "Do you want to play again? (y or n)"
  answer = gets.chomp
  valid = ['y','n'].include?(answer)
  unless valid
    prompt "Sorry, must enter 'y' or 'n'." 
  end
  answer.downcase.start_with?('y')
end

def exit_game?
  puts "------------"
  prompt "Are you sure you want to exit Twenty-One? 
  Press 'y' to exit and 'n' to start a new game."
  answer = gets.chomp
  valid = ['y','n'].include?(answer)
  unless valid
    prompt "Sorry, must enter 'y' or 'n'." 
  end
  answer.downcase.start_with?('y')
end

loop do
  p_matches_won = []
  d_matches_won = []

  loop do
    prompt "Welcome to Twenty-One!"

    # initialize vars
    deck = initialize_deck
    player_cards = []
    dealer_cards = []
    p_total = 0
    d_total = 0

    # initial deal
    2.times do
      player_cards << deck.pop
      dealer_cards << deck.pop
    end

    p_total = total(player_cards)
    d_total = total(dealer_cards)

    prompt "Dealer has #{dealer_cards[0]} and...?"
    prompt "You have: #{player_cards[0]} and #{player_cards[1]},
    for a total of #{p_total}."

    # player turn
    loop do
      player_turn = nil
      loop do
        prompt "Would you like to (h)it or (s)tay?"
        player_turn = gets.chomp.downcase
        break if ['h', 's'].include?(player_turn)
        prompt "Sorry, must enter 'h' or 's'."
      end

      if player_turn == 'h'
        player_cards << deck.pop
        p_total = total(player_cards)
        prompt "You chose to hit!"
        prompt "Your cards are now: #{player_cards}"
        prompt "Your total is now: #{p_total}"
      end

      break if player_turn == 's' || busted?(player_cards)
    end

    if busted?(player_cards)
      match_won(d_total, p_total, d_matches_won, p_matches_won)
      play_again? ? next : break
    else
      prompt "You stayed at #{p_total}"
    end

    # dealer turn
    prompt "Dealer turn..."

    loop do
      break if busted?(dealer_cards) || d_total >= BUST_VALUE - 4

      prompt "Dealer hits!"
      dealer_cards << deck.pop
      d_total = total(dealer_cards)
      prompt "Dealer's cards are now: #{dealer_cards}"
    end

    if busted?(dealer_cards)
      prompt "Dealer total is now #{d_total}"
      match_won(d_total, p_total, d_matches_won, p_matches_won)
      play_again? ? next : break
    else
      prompt "Dealer stays at #{d_total}"
    end

    # both player and dealer stays = compare cards!
    puts "============="
    prompt "Dealer has #{dealer_cards}, for a total of: #{d_total}"
    prompt "Player has #{player_cards}, for a total of: #{p_total}"
    puts "============="

    match_won(d_total, p_total, d_matches_won, p_matches_won)
    break unless play_again?
  end
  break if exit_game?
end
prompt "Thank you for playing Twenty-One! Good bye!"
