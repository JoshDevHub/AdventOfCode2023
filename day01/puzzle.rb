data = File.readlines(*ARGV, chomp: true)

NUM_WORDS = %w[zero one two three four five six seven eight nine].freeze

def extract_two_digit_num(string)
  numbers = string.scan(/\d/)
  "#{numbers[0]}#{numbers[-1]}".to_i
end

first_calibration = data.sum { |line| extract_two_digit_num(line) }

p first_calibration # p1

second_calibration = data.sum do |line|
  NUM_WORDS.each_with_index { |w, i| line.gsub!(w, "#{w}#{i}#{w}") }
  extract_two_digit_num(line)
end

p second_calibration # p2
