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

SUITS = ['Hearts','Clubs', 'Diamonds', 'Spades'].freeze
CARD_VALUES = {'2' => 2,  '3' => 3, '4' => 4, '5' => 5, 
              '6' => 6, '7' => 7, '8' => 8, '9' => 9, '10' => 10, 'Jack' => 10, 
              'Queen' => 10, 'King' => 10, 'Ace' => 10 }.freeze
CARD_TYPES = CARD_VALUES.keys.freeze

def prompt(msg)
  puts " => #{msg}"
end

def make_cards
  cards = []
    CARD_TYPES.each do |type|
      SUITS.each { |name| cards << [type, name, CARD_VALUES.values_at(type)].flatten }
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
  player_hand.each { |type, name, value| player_total += value }
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

player_hand = []
dealer_hand = []
player_move = ''
initial_deck = make_cards
draw_pile = initial_deck
player_total = 0
dealer_total = 0

# the dealer draws and hands are compared
loop do

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
    break if player_move == 's'
  end

  prompt "There are #{draw_pile.count} cards remaining."
  # check to see if the player busts - if so, dealer wins automatically
  busted?(player_total)

  # dealer's turns
  while dealer_total < 18
    dealer_draws_card(draw_pile, dealer_hand)
    dealer_total
  end
  prompt "Dealer has the following cards in their hand:"
  human_friendly_names(dealer_hand)
  dealer_total = value_of_hand(dealer_hand)
  busted?(dealer_total)

end
