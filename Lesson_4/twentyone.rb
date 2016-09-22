require 'pry'

# twentyone.rb
# 1. Initialize deck
# 2. Deal cards to player and dealer
# 3. Player turn: hit or stay
#   - repeat until bust or "stay"
# 4. If player bust, dealer wins.
# 5. Dealer turn: hit or stay
#   - repeat until total >= 17
# 6. If dealer bust, player wins.
# 7. Compare cards and declare winner.

SUITS = ['Hearts', 'Clubs', 'Diamonds', 'Spades'].freeze
CARD_VALUES = { '2' => 2, '3' => 3, '4' => 4, '5' => 5,
                '6' => 6, '7' => 7, '8' => 8, '9' => 9,
                '10' => 10, 'Jack' => 10, 'Queen' => 10,
                'King' => 10, 'Ace' => 10 }.freeze
CARD_TYPES = CARD_VALUES.keys.freeze
BUST_VALUE = 21.freeze

def prompt(msg)
  puts " => #{msg}"
end

def make_cards
  cards = []
  CARD_TYPES.each do |type|
    SUITS.each do |name|
      cards << [type, name, CARD_VALUES.values_at(type)].flatten
    end
  end
  cards.shuffle
end

def player_draws_card(draw_pile, player_hand)
  # give the player a random available card
  drawn_card = draw_pile.pop
  # make an array of what cards the player has
  player_hand << drawn_card
  player_hand
  # binding.pry
end

def dealer_draws_card(draw_pile, dealer_hand)
  #   give the dealer a random available card
  drawn_card = draw_pile.pop
  #   make an array of what cards the dealer has
  dealer_hand << drawn_card
  dealer_hand
end

# turn the player_hand array into legible card descriptions
def human_friendly_names(drawn_hand)
  drawn_hand.each { |type, name| prompt "#{type} of #{name}" }
end

# tell what the value of a player's hand is at a given point in time
def value_of_hand(cards)
  player_total = 0
  cards.each do |type, _name, value|
    if type == 'Ace' && player_total < BUST_VALUE + 1
      value = 10
    elsif type == 'Ace' && player_total > BUST_VALUE
      value = 1
    end
    player_total += value
  end
  player_total
end

def busted?(cards)
  value_of_hand(cards) > BUST_VALUE
end

def determine_winner(dealer_hand, player_hand)
  player_total = value_of_hand(player_hand)
  dealer_total = value_of_hand(dealer_hand)

  if player_total > BUST_VALUE
    :player_busted
  elsif dealer_total > BUST_VALUE
    :dealer_busted
  elsif dealer_total < player_total
    :player_wins
  elsif dealer_total > player_total
    :dealer_wins
  else
    :tie
  end
end

def assign_winner(dealer_hand, player_hand)
  result = determine_winner(dealer_hand, player_hand)
  case result
  when :player_busted
    prompt "You busted. Dealer wins!"
  when :tie
    prompt "You managed a tie."
  when :player_wins
    prompt "Congratulations! Player wins."
  when :dealer_wins
    prompt "Tough. Dealer wins."
  end
end

def play_again?
  puts "------------"
  prompt "Do you want to play again? (y or n)"
  answer = gets.chomp
  answer.downcase.start_with?('y')
end

loop do
  player_hand = []
  dealer_hand = []
  player_move = ''
  initial_deck = make_cards
  draw_pile = initial_deck
  player_total = 0
  dealer_total = 0

  # this loop is the player's set of turns to get to BUST_VALUE
  loop do
    # give player an opportunity to hit or stay
    loop do
      prompt "Press 'H' to hit and draw a card or 'S' to stay."
      player_move = gets.chomp.downcase
      break if player_move == 'h' || player_move == 's'
      prompt "I didn't understand, please try again."
    end

    if player_move == 'h'
      player_draws_card(draw_pile, player_hand)
      prompt "You have the following cards in your hand:"
      human_friendly_names(player_hand)
    elsif player_move == 's'
      prompt "You chose to stay."
    end
    player_total = value_of_hand(player_hand)
    prompt "The value of your hand is now #{player_total}"
    # check to see if the player busts - if so, dealer wins automatically
    break if busted?(player_hand)
    break if player_move == 's'
  end

  prompt "There are #{draw_pile.count} cards remaining."

  # dealer's turns
  prompt "Dealer draws...\
  "

  loop do
    if dealer_total <= BUST_VALUE - 4
      dealer_draws_card(draw_pile, dealer_hand)
      dealer_total = value_of_hand(dealer_hand)
    end
    break if dealer_total > BUST_VALUE - 4
  end
  puts "\
  "
  prompt "Dealer has the following cards in their hand:"
  puts "\
  "
  human_friendly_names(dealer_hand)
  prompt "The value of the dealer's hand is now #{dealer_total}"

  # the dealer draws and hands are compared
  assign_winner(dealer_hand, player_hand)

  break unless play_again?
end

prompt "Thank you for playing Twenty-One! Good bye!"
  
