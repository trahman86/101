
def prompt(message)
  Kernel.puts("=> #{message}")
end

def integer?(int)
  int.to_i.to_s == int
end

def float?(num)
  num.to_f.to_s == num
end

def number?(input)
  integer?(input) || float?(input)
end

def monthly_payment(loan_amount,monthly_int,loan_duration)
  # Formula for monthly payments
  # P = L[c(1 + c)^n]/[(1 + c)^n - 1]
  numerator = loan_amount * ((monthly_int / 100) * (1 + (monthly_int / 100)) ** loan_duration)
  denominator = ((1 + (monthly_int / 100)) ** loan_duration - 1).round(2)
  numerator / denominator
end


# Main program loop
loop do
  # Main loan amount loop
  loan_amount = ''
  loop do
    # What is the amount of your loan?
    loop do
      prompt("How much is your loan in US dollars (round to the nearest dollar)?")
      loan_amount = Kernel.gets().chomp()

      if integer?(loan_amount)
        loan_amount = loan_amount.to_i
        break
      else
        prompt("Please enter a numeric loan amount.")
      end
    end

    loan_amount_check = <<-MSG
    Okay, your loan is $#{loan_amount}.
    Is this correct?

    Type 'Y' to continue or 'N' to try again.
    MSG
    prompt(loan_amount_check)
    answer = Kernel.gets().chomp()
    break unless answer.downcase().start_with?('n')
  end

  # Main APR loop
  apr = ''
  loop do
    # What is the APR?
    loop do
      prompt("What is your APR as a percentage out of 100 (include decimals)?")
      apr = Kernel.gets().chomp()

      if number?(apr) && apr.to_f.between?(0, 100)
        apr = apr.to_f
        break
      else
        prompt("Please enter a percentage between 0 and 100 with only numeric values.")
      end
    end

    apr_check = <<-MSG
    Okay, your APR is #{apr}%.
    Is this correct?

    Type 'Y' to continue or 'N' to try again.
    MSG
    prompt(apr_check)
    answer = Kernel.gets().chomp()
    break unless answer.downcase().start_with?('n')
  end

  # Main loan duration loop
  loan_duration = ''
  loop do
    # How long is your loan?
    loop do
      prompt("How long is your loan in months?")
      loan_duration = Kernel.gets().chomp()

      if integer?(loan_duration)
        loan_duration = loan_duration.to_i
        break
      else
        prompt("Please enter a a number of months above 0.")
      end
    end

    duration_check = <<-MSG
    Okay, your loan duration is #{loan_duration} months.
    Is this correct?

    Type 'Y' to continue or 'N' to try again.
    MSG
    prompt(duration_check)
    answer = Kernel.gets().chomp()
    break unless answer.downcase().start_with?('n')
  end

  monthly_int = (apr / 12).round(2)

  payment_plan_details = <<-MSG
  Great! Based on your information...
  Your monthly interest rate is
  #{monthly_int}%. 

  Your monthly loan payment should be
  $#{monthly_payment(loan_amount,monthly_int,loan_duration).round(2)}.
  MSG

  prompt(payment_plan_details)

  prompt("Do you have another loan to calculate? (Y to calculate again)")
  answer = Kernel.gets().chomp()
  break unless answer.downcase().start_with?('y')
end

prompt("Goodbye!")
puts "\n-------------------------------------------------------------------"