# Question 1

# Let's do some "ASCII Art" (a stone-age form of nerd artwork from back in the days before computers had video screens).

# For this exercise, write a one-line program that creates the following output 10 times, with the subsequent line indented 1 space to the right:

# The Flintstones Rock!
#  The Flintstones Rock!
#   The Flintstones Rock!

10.times { |number| puts (' ' * number) + 'The Flintstones Rock!' }


# Question 2

# Create a hash that expresses the frequency with which each letter occurs in this string:

statement = "The Flintstones Rock"

# ex:

# { "F"=>1, "R"=>1, "T"=>1, "c"=>1, "e"=>2, ... }
result = {}
letters = ('A'..'Z').to_a + ('a'..'z').to_a
letters.each do |letter|
  letter_frequency = statement.scan(letter).count
  result[letter] = letter_frequency if letter_frequency > 0
end

# Question 3

# The result of the following statement will be an error:

puts "the value of 40 + 2 is " + (40 + 2) # mixes datatypes; can't concatenate the non-string
# change calculation to a string or use string interpolation
# 

# Why is this and what are two possible ways to fix this?

# Question 4

# What happens when we modify an array while we are iterating over it? What would be output by this code?

numbers = [1, 2, 3, 4]
numbers.each do |number|
  p number
  numbers.shift(1)
end
# Prints a value and then shifts the values out in the array one to the right. 
# The next result will skip over one in the array so you'll drop alternating values from the array
# Output is [1,3]

# What would be output by this code?

numbers = [1, 2, 3, 4]
numbers.each do |number|
  p number
  numbers.pop(1)
end
# This does a similar thing except now it will drop values from the end twice until the array terminates
# Output is [1,2]

# Question 5

# Alan wrote the following method, which was intended to show all of the factors of the input number:

def factors(number)
  dividend = number
  divisors = []
  while dividend > 0 do
    divisors << number / dividend if number % dividend == 0
    dividend -= 1
  end
  divisors
end

# Alyssa noticed that this will fail if you call this with an input of 0 or a negative number and asked Alan to change the loop. 
# How can you change the loop construct (instead of using begin/end/until) to make this work? 
# Note that we're not looking to find the factors for 0 or negative numbers, but we just want to handle it gracefully 
# instead of raising an exception or going into an infinite loop.

# Bonus 1

# What is the purpose of the number % dividend == 0 ?
# To be a factor, there must be no remainder when the number is divided.

# Bonus 2
# What is the purpose of the second-to-last line in the method (the divisors before the method's end)?
# Return the value of the array to ensure and make explicit that that is what the method returns

# Question 6

# Alyssa was asked to write an implementation of a rolling buffer. 
# Elements are added to the rolling buffer and if the buffer becomes full, then new elements that are added will displace the oldest elements in the buffer.

# She wrote two implementations saying, "Take your pick. Do you like << or + for modifying the buffer?". 
# Is there a difference between the two, other than what operator she chose to use to add an element to the buffer?

def rolling_buffer1(buffer, max_buffer_size, new_element)
  buffer << new_element
  buffer.shift if buffer.size >= max_buffer_size
  buffer
end

def rolling_buffer2(input_array, max_buffer_size, new_element)
  buffer = input_array + [new_element]
  buffer.shift if buffer.size >= max_buffer_size
  buffer
end

# The << operator mutates the buffer that is passed in from the method caller. 
# The second uses a separate variable for these values, so only the buffer is modified rather than what was passed in.

# Question 7

# Alyssa asked Ben to write up a basic implementation of a Fibonacci calculator, A user passes in two numbers, and the calculator will keep computing 
# the sequence until some limit is reached.

# Ben coded up this implementation but complained that as soon as he ran it, he got an error. Something about the limit variable. What's wrong with the code?


def fib(first_num, second_num)
  limit = 15
  while second_num < limit
    sum = first_num + second_num
    first_num = second_num
    second_num = sum
  end
  sum
end

result = fib(0, 1)
puts "result is #{result}"

# How would you fix this so that it works?
# The limit is outside of the scope of the method. Either define the variable within the method, or nest the method in a larger loop.

# Question 8

# In another example we used some built-in string methods to change the case of a string. 
# A notably missing method is something provided in Rails, but not in Ruby itself...titleize! 
# This method in Ruby on Rails creates a string that has each word capitalized as it would be in a title.

# Write your own version of the rails titleize implementation.

string = 'this is a sentence.'
def titleize(words)
  letters = string.each_char.to_a
  letters[0].capitalize!
  letters.each_with_index do |letter, index|
    if letter == " "
      letters[index + 1].capitalize!
    end
  end
  letters.join
end

string = titleize(string)

# ---- Textbook solution

words.split.map { |word| word.capitalize }.join(' ')

# Question 9

# Given the munsters hash below

munsters = {
  "Herman" => { "age" => 32, "gender" => "male" },
  "Lily" => { "age" => 30, "gender" => "female" },
  "Grandpa" => { "age" => 402, "gender" => "male" },
  "Eddie" => { "age" => 10, "gender" => "male" },
  "Marilyn" => { "age" => 23, "gender" => "female"}
}

# Modify the hash such that each member of the Munster family has an additional "age_group" key 
# that has one of three values describing the age group the family member is in (kid, adult, or senior). 
# Your solution should produce the hash below

{ "Herman" => { "age" => 32, "gender" => "male", "age_group" => "adult" },
  "Lily" => {"age" => 30, "gender" => "female", "age_group" => "adult" },
  "Grandpa" => { "age" => 402, "gender" => "male", "age_group" => "senior" },
  "Eddie" => { "age" => 10, "gender" => "male", "age_group" => "kid" },
  "Marilyn" => { "age" => 23, "gender" => "female", "age_group" => "adult" } }

# Note: a kid is in the age range 0 - 17, an adult is in the range 18 - 64 and a senior is aged 65+.

# hint: try using a case statement along with Ruby Range objects in your solution

munsters.each do |whoever, demographics| 
  case ['age']
    when 0...17
      demographics['age_group'] = 'kid'
    when 18...64
      demographics['age_group'] = 'adult'
    else
      demographics['age_group'] = 'senior'
  end
end
