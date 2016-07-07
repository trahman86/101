VALID_CHOICES = %w(rock paper scissors spock lizard)
VALID_SHORT_CHOICES = []

def prompt(message)
  Kernel.puts("=> #{message}")
end

def make_short_choice
  VALID_CHOICES.each do |selection|
    short_choice = if VALID_SHORT_CHOICES.include?(selection[0])
                     selection[0..1]
                   else
                     selection[0]
                   end
    VALID_SHORT_CHOICES << short_choice
  end
end

make_short_choice()

def win?(winner, loser)
  VALID_CHOICES[loser] == VALID_CHOICES[(winner - 1)] ||
    VALID_CHOICES[loser] == VALID_CHOICES[(winner - 3)]
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
computer_selection = ''
player_score = 0
computer_score = 0
# This loop determines the outcome of a single round
loop do
  # Display the score
  prompt("The score is currently - player: #{player_score}
    computer #{computer_score}")
  # This loop gets input from the user and makes it usable for the game
  loop do
    # Ask user to choose
    prompt("Choose one: #{VALID_CHOICES.join(', ')}")
    prompt("You can enter the following hotkeys for faster gameplay:
      #{VALID_SHORT_CHOICES.join(', ')}")
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
  computer_selection = VALID_CHOICES.index(computer_choice)
  prompt("You chose: #{VALID_CHOICES[selection]};
    Computer chose: #{computer_choice}")

  display_result(selection, VALID_CHOICES.index(computer_choice))

  # Update the scores at the end of the round
  if win?(selection, VALID_CHOICES.index(computer_choice))
    player_score += 1
  elsif win?(VALID_CHOICES.index(computer_choice), selection)
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
