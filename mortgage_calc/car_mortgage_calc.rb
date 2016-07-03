require 'yaml'
MESSAGES = YAML.load_file('mortgage_msgs.yml')

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

def make_correction?
  loop do
    prompt(MESSAGES['check'])
    answer = Kernel.gets().chomp().downcase()
    break false if %w(y yes).include?(answer)
    break true if %w(n no).include?(answer)
  end
end

def monthly_payment(amount, m_int, duration)
  # Formula for monthly payments
  # P = L[c(1 + c)^n]/[(1 + c)^n - 1]
  if m_int == 0.0
    numerator = amount
    denominator = duration
  else
    numerator = amount * (m_int * (1 + m_int)**duration)
    denominator = (1 + m_int)**duration - 1
  end
  numerator / denominator
end

def run_again?
  loop do
    prompt(MESSAGES['end_of_program'])
    answer = Kernel.gets().chomp().downcase()
    break true if %w(y yes).include?(answer)
    break false if %w(n no).include?(answer)
  end
end

# Main program loop
loop do
  # Main loan amount loop
  amount = ''
  loop do
    # What is the amount of your loan?
    loop do
      prompt(MESSAGES['get_amount'])
      amount = Kernel.gets().chomp()

      if number?(amount)
        amount = amount.to_f
        break
      else
        prompt(MESSAGES['amount_error'])
      end
    end
    prompt(MESSAGES['amount_statment'] + "#{amount}.")
    break unless make_correction?
  end

  # Main APR loop
  apr = ''
  loop do
    # What is the APR?
    loop do
      prompt(MESSAGES['get_apr'])
      apr = Kernel.gets().chomp()

      if number?(apr) && apr.to_f.between?(0, 100)
        apr = apr.to_f
        break
      else
        prompt(MESSAGES['apr_error'])
      end
    end
    prompt(MESSAGES['apr_statement'] + "#{apr}%.")
    break unless make_correction?
  end

  # Main loan duration loop
  duration = ''
  loop do
    # How long is your loan?
    loop do
      prompt(MESSAGES['get_duration'])
      duration = Kernel.gets().chomp()

      if integer?(duration)
        duration = duration.to_i
        break
      else
        prompt(MESSAGES['duration_error'])
      end
    end
    prompt(MESSAGES['duration_statement'] + "#{duration} months.")
    break unless make_correction?
  end

  m_int = (apr / 100) / 12

  prompt(MESSAGES['m_int_statment'] + "#{format('%02.2f', m_int * 100)}%")

  if duration == 0
    prompt(MESSAGES['zero_duration'] + "format('%02.2f', amount)")
  else
    prompt(MESSAGES['payment_plan_statement'] +
  "#{format('%02.2f', monthly_payment(amount, m_int, duration))}.")
  end
  break unless run_again?
end

prompt(MESSAGES['bye'])
