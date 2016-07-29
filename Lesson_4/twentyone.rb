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
  cards
end

def available_cards(draw_pile, drawn_card)
  # remove the card just drawn
  draw_pile.delete(drawn_card)
  draw_pile
end

def player_draws_card(draw_pile, player_hand)
  # give the player a random available card
  drawn_card = draw_pile.sample
  # make an array of what cards the player has
  player_hand << drawn_card
  available_cards(draw_pile, drawn_card)
  player_hand
  # binding.pry
end

def dealer_draws_card(draw_pile, dealer_hand)
  #   give the dealer a random available card
  drawn_card = draw_pile.sample
  #   make an array of what cards the dealer has
  dealer_hand << drawn_card
  available_cards(draw_pile, drawn_card)
  dealer_hand
end

# turn the player_hand array into legible card descriptions
def human_friendly_names(drawn_hand)
  drawn_hand.each { |type, name| prompt "#{type} of #{name}" }
end

# tell what the value of a player's hand is at a given point in time
def value_of_hand(player_hand)
  player_total = 0
  player_hand.each do |type, _name, value|
    if type == 'Ace' && player_total < 12
      value = 10
    elsif type == 'Ace' && player_total > 11
      value = 1
    end
    player_total += value
  end
  player_total
end

def busted?(total)
  if total < 22
    prompt "Nice. Under 21."
  elsif total == 21
    prompt "Whoa, exactly 21!"
  else
    prompt "Busted!"
  end
end

def assign_winner(player_total, dealer_total)
  if player_total > 22
    prompt "You busted. Dealer wins!"
  elsif dealer_total == 0
    prompt "Dealer's turn..."
  elsif player_total == dealer_total
    prompt "You managed a tie."
  elsif (21 - player_total) < (21 - dealer_total)
    prompt "Congratulations! Player wins."
  else
    prompt "Tough. Dealer wins."
  end
end

player_hand = []
dealer_hand = []
player_move = ''
initial_deck = make_cards
draw_pile = initial_deck
player_total = 0
dealer_total = 0

# this loop is the player's set of turns to get to 21
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
    player_total = value_of_hand(player_hand)
  end
  prompt "The value of your hand is now #{value_of_hand(player_hand)}"
  # busted?(player_total)
  break if player_move == 's'
end

prompt "There are #{draw_pile.count} cards remaining."
# check to see if the player busts - if so, dealer wins automatically

# dealer's turns

loop do
  if dealer_total <= 17
    dealer_draws_card(draw_pile, dealer_hand)
    prompt "Dealer has the following cards in their hand:"
    human_friendly_names(dealer_hand)
    dealer_total = value_of_hand(dealer_hand)
  end
  prompt "The value of the dealer's hand is now #{value_of_hand(dealer_hand)}"
  break if dealer_total > 17
end

# the dealer draws and hands are compared
assign_winner(player_total, dealer_total)
