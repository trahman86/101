# START

# # Given a collection of integers called "numbers"

# SET iterator = 1
# SET saved_number = value within numbers collection at space 1

# WHILE iterator < length of numbers
#   SET current_number = value within numbers collection at space "iterator"
#   IF saved_number >= current_number
#     go to the next iteration
#   ELSE
#     saved_number = current_number

#   iterator = iterator + 1

# PRINT saved_number

# END

# to 

# def find_greatest(numbers)
#   saved_number = nil

#   numbers.each do |num|
#     saved_number ||= num # assign to first value
#     if 
#       saved_number >= num
#       next
#     else 
#       saved_number = num
#     end
#   end

#   saved_number
# end

1. a method that returns the sum of two integers

Casual

Given a first integer and a second integer
Find the sum of the two integers
And return a result

Formal

START

SET integer1 = a first value

SET integer2 = a second value

READ integer1 and integer2
  sum of integer1 and integer2
RETURN value

END

2.a method that takes an array of strings, and returns a string that is all those strings concatenated together

Casual

Given an array of strings
For each string, add each one to the next
Return this value

Formal

START

SET array = some list of strings

WHILE n < length of the array + 1
  JOIN string[n] and string[n+1]
RETURN value

END


3.a method that takes an array of integers, and returns a new array with every other element

Casual

Given an array of integers.
Select the alternating elements
Return those values to a new array


Formal

START

SET array = [integers]

WHILE array.idx is odd
  Push each new integer into array2
RETURN values

END

END
