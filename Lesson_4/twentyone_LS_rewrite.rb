SUITS = ['Hearts', 'Diamonds', 'Spades', 'Clubs']
VALUES = ['2', '3', '4,', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King', 'Ace']
BUST_VALUE = 21.freeze

def prompt(msg)
  puts "=> #{msg}"
end

def initialize_deck 
  # this creates a shuffled deck of cards as a nested array
  SUITS.product(VALUES).shuffle
end

def total(cards)
  # card = [['H', '3'], ['S', 'Q'], ... ]
  # for each card, the value is taken from the second spot in the inside array
  values = cards.map { |card| card[1] }

  sum = 0
  values.each do |value|
    if value == "Ace"
      sum += 11
    elsif value.to_i == 0 # J, Q, K
      sum += 10
    else
      sum += value.to_i
    end
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
def detect_result(dealer_total, player_total)
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

def display_result(dealer_total, player_total, dealer_matches_won, player_matches_won)
  result = detect_result(dealer_total, player_total)

  case result
  when :player_busted
    dealer_matches_won << 1
    prompt "You busted! Dealer wins!"
  when :dealer_busted
    player_matches_won << 1
    prompt "Dealer busted! You win!"
  when :player_wins
    player_matches_won << 1
    prompt "You win!"
  when :dealer_wins
    dealer_matches_won << 1
    prompt "Dealer wins!"
  when :tie
    prompt "It's a tie!"
  end
end

def match_won(dealer_total, player_total, dealer_matches_won, player_matches_won)
  display_result(dealer_total, player_total, dealer_matches_won, player_matches_won)
  case
  when dealer_matches_won.length < 5 && player_matches_won.length < 5
    prompt "Dealer has won #{dealer_matches_won.length} hands.
    You've won #{player_matches_won.length} hands."
  when dealer_matches_won.length == 5 && player_matches_won.length < 5
    prompt "Game over. Dealer wins the game!"
    dealer_matches_won.delete(1)
    player_matches_won.delete(1)
  when player_matches_won.length == 5 && dealer_matches_won.length < 5
    prompt "Game over. Player wins the game!"
    dealer_matches_won.delete(1)
    player_matches_won.delete(1)
  end
end

def play_again?
  puts "------------"
  prompt "Do you want to play again? (y or n)"
  answer = gets.chomp
  answer.downcase.start_with?('y')
end

loop do
  player_matches_won = []
  dealer_matches_won = []

  loop do
    prompt "Welcome to Twenty-One!"

    # initialize vars
    deck = initialize_deck
    player_cards = []
    dealer_cards = []
    player_total = 0
    dealer_total = 0

    # initial deal
    2.times do
      player_cards << deck.pop
      dealer_cards << deck.pop
    end
    
    player_total = total(player_cards)
    dealer_total = total(dealer_cards)

    prompt "Dealer has #{dealer_cards[0]} and...?"
    prompt "You have: #{player_cards[0]} and #{player_cards[1]},
    for a total of #{player_total}."

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
        player_total = total(player_cards)
        prompt "You chose to hit!"
        prompt "Your cards are now: #{player_cards}"
        prompt "Your total is now: #{player_total}"
      end

      break if player_turn == 's' || busted?(player_cards)
    end

    if busted?(player_cards)
      match_won(dealer_total, player_total, dealer_matches_won, player_matches_won)
      play_again? ? next : break
    else
      prompt "You stayed at #{player_total}"
    end

    # dealer turn
    prompt "Dealer turn..."

    loop do
      break if busted?(dealer_cards)  || dealer_total >= BUST_VALUE - 4

      prompt "Dealer hits!"
      dealer_cards << deck.pop
      dealer_total = total(dealer_cards)
      prompt "Dealer's cards are now: #{dealer_cards}"
    end

    if busted?(dealer_cards)
      prompt "Dealer total is now #{dealer_total}"
      match_won(dealer_total, player_total, dealer_matches_won, player_matches_won)
      play_again? ? next : break
    else
      prompt "Dealer stays at #{dealer_total}"
    end

    # both player and dealer stays = compare cards!
    puts "============="
    prompt "Dealer has #{dealer_cards}, for a total of: #{dealer_total}"
    prompt "Player has #{player_cards}, for a total of: #{player_total}"
    puts "============="

    match_won(dealer_total, player_total, dealer_matches_won, player_matches_won)

    break unless play_again?
  end
end
prompt "Thank you for playing Twenty-One! Good bye!"
