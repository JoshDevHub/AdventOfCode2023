cards = File.readlines(ARGV[0], chomp: true)

points = 0
card_counts = []

cards.each_with_index do |card, idx|
  _, winning_numbers, my_numbers = card.split(/:\s|\s\|\s/).map(&:split)

  card_counts[idx] = card_counts[idx].to_i + 1
  matches = my_numbers.count { |n| winning_numbers.include?(n) }

  next if matches.zero?

  points += 2**(matches - 1)

  curr_card_count = card_counts[idx]
  ((idx + 1)..(idx + matches)).each do |copy_idx|
    card_counts[copy_idx] = card_counts[copy_idx].to_i + curr_card_count
  end
end

p points # p1

p card_counts.sum(&:to_i) # p2
