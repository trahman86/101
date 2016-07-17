def make_uuid()
  random_numbers = ['0','1','2','3','4','5','6','7','8','9']
  lower_letters = ('a'..'z').to_a
  upper_letters = ('A'..'Z').to_a
  choices = [random_numbers, lower_letters, upper_letters]
  section_1 = ['','','','','','','','']
  section_2 = ['','','','']
  section_3 = ['','','','']
  section_4 = ['','','','']
  section_5 = ['','','','','','','','','','','','']
  section_1.each_with_index { |value, index| value << choices[rand(0..2)].sample }
  section_2.each_with_index { |value, index| value << choices[rand(0..2)].sample }
  section_3.each_with_index { |value, index| value << choices[rand(0..2)].sample }
  section_4.each_with_index { |value, index| value << choices[rand(0..2)].sample }
  section_5.each_with_index { |value, index| value << choices[rand(0..2)].sample }
  section_1 = section_1.join('')
  section_2 = section_2.join('')
  section_3 = section_3.join('')
  section_4 = section_4.join('')
  section_5 = section_5.join('')
  uuid = [section_1, section_2, section_3, section_4, section_5].join('-')
  p uuid
end

make_uuid
