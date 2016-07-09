# Question 1

# What would you expect the code below to print out?

numbers = [1, 2, 2, 3]
numbers.uniq

puts numbers #<= 1,2,2,3

# Question 2

# Describe the difference between ! and ? in Ruby. And explain what would happen in the following scenarios:

# ! is often a signal that a destructive change has taken place if after a method. Before a variable it negates it.
# 

    # what is != and where should you use it? # Determining values are not equal
    # put ! before something, like !user_name # logical NOT - gives you the boolean and then flips that
    # put ! after something, like words.uniq! # often a signal of a destructive method that will alter the original reference
    # put ? before something # conditional - part of an operator to determine if a value is true or false
    # put ? after something # often a signal on a method that a true or false condition is determined
    # put !! before something, like !!user_name # gives you the boolean equivalent

# Question 3

# Replace the word "important" with "urgent" in this string:

advice = "Few things in life are as important as house training your pet dinosaur."
advice.gsub!(/important/, 'urgent')

# Question 4

# The Ruby Array class has several methods for removing items from the array. Two of them have very similar names. 
# Let's see how they differ:

numbers = [1, 2, 3, 4, 5]

# What does the follow method calls do (assume we reset numbers to the original array between method calls)?

numbers.delete_at(1) # Deletes the value at index 1
numbers.delete(1) # Deletes the value 1

# Question 5

# Programmatically determine if 42 lies between 10 and 100.

# hint: Use Ruby's range object in your solution.
answer = 42
range = (10..100)
range.cover?(answer)

# Question 6

# Starting with the string:

famous_words = "seven years ago..."

# show two different ways to put the expected "Four score and " in front of it.

famous_words.prepend("Four score and ")
famous_words = "Four score and " + famous_words

# Question 7

# Fun with gsub:

def add_eight(number)
  number + 8
end

number = 2

how_deep = "number"
5.times { how_deep.gsub!("number", "add_eight(number)") }

p how_deep

# This gives us a string that looks like a "recursive" method call:

# "add_eight(add_eight(add_eight(add_eight(add_eight(number)))))"

# If we take advantage of Ruby's Kernel#eval method to have it execute this string as if it were a "recursive" method call

p eval(how_deep) 

# what will be the result?
# 42. 2 is passed in as the first number and then the sum is used for each subsequent operation

# Question 8

# If we build an array like this:

flintstones = ["Fred", "Wilma"]
flintstones << ["Barney", "Betty"]
flintstones << ["BamBam", "Pebbles"]

# We will end up with this "nested" array:

# ["Fred", "Wilma", ["Barney", "Betty"], ["BamBam", "Pebbles"]]

# Make this into an un-nested array.

flintstones.flatten!()

# Question 9

# Given the hash below

flintstones = { "Fred" => 0, "Wilma" => 1, "Barney" => 2, "Betty" => 3, "BamBam" => 4, "Pebbles" => 5 }

# Turn this into an array containing only two elements: Barney's name and Barney's number

flintstones.select {|k,v| k == "Barney"}.to_a.flatten!

# Better 
flintstones.assoc("Barney")


# Question 10

# Given the array below

flintstones = ["Fred", "Barney", "Wilma", "Betty", "Pebbles", "BamBam"]

# Turn this array into a hash where the names are the keys and the values are the positions in the array.
flint_hash = {}
flintstones.each_with_index do |name, index|
  flint_hash[name] = index
end
