VALID_CHOICES = %w(rock paper scissors lizard spock)
VALID_SHORT_CHOICES =[]

def prompt(message)
  Kernel.puts("=> #{message}")
end

def make_short_choice
  VALID_CHOICES.each_with_index do |selection, idx|
    if VALID_SHORT_CHOICES.include?(selection[0])
      short_choice = selection[0..1]
    else
      short_choice = selection[0]
    end
  VALID_SHORT_CHOICES << short_choice
  end
end

make_short_choice()

def win?(first, second)
  (first == 'rock' && (second == 'scissors' || second == 'lizard')) ||
    (first == 'paper' && (second == 'rock' || second == 'spock')) ||
    (first == 'scissors' && (second == 'paper' || second == 'lizard')) ||
    (first == 'lizard' && (second == 'spock' || second == 'paper')) ||
    (first == 'spock' && (second == 'scissors' || second == 'rock'))
end

def display_result(player, computer)
  if win?(player, computer)
    prompt("You won!")
  elsif win?(computer, player)
    prompt("Computer won!")
  else
    prompt("It's a tie!")
  end
end

def run_again?
  loop do
    prompt("Do you want to play again? Y for yes, N for no.")
    answer = Kernel.gets().chomp().downcase()
    break true if %w(y yes).include?(answer)
    break false if %w(n no).include?(answer)
    prompt("I didn't understand.")
  end
end

choice = ''
selection = ''
player_score = 0
computer_score = 0
# This loop determines the outcome of a single round
loop do
  # This loop gets input from the user and makes it usable for the game
  prompt("The score is currently - player: #{player_score}  computer #{computer_score}")
  loop do
    #Display the score
    # Ask user to choose
    prompt("Choose one: #{VALID_CHOICES.join(', ')}")
    prompt("You can enter the following hotkeys for faster gameplay: #{VALID_SHORT_CHOICES.join(', ')}")
    choice = Kernel.gets().chomp()

    # Validate that the user has submitted a valid choice
    if VALID_CHOICES.include?(choice)
      selection = VALID_CHOICES.index(choice)
      break
    elsif VALID_SHORT_CHOICES.include?(choice)
      selection = VALID_SHORT_CHOICES.index(choice)
      break
    else
      prompt("That's not a valid choice.")
    end
  end
  
  # Computer chooses
  computer_choice = VALID_CHOICES.sample
  prompt("You chose: #{VALID_CHOICES[selection]}; Computer chose: #{computer_choice}")
  
  display_result(VALID_CHOICES[selection], computer_choice)

  # Update the scores at the end of the round
  if win?(VALID_CHOICES[selection], computer_choice)
    player_score += 1
  elsif win?(computer_choice, VALID_CHOICES[selection])
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
prompt("Thank you for playing! Goodbye.")

