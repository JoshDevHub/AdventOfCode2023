DAMAGED_CHARS = "?#".freeze
SUBSTITUTIONS = "#.".freeze

def memoized_count(springs, group_sizes, memo = {})
  memo[[springs, group_sizes]] ||=
    case springs[0]
    when "." then memoized_count(springs[1..], group_sizes, memo)
    when "?" then branch_for_unknown(springs, group_sizes, memo)
    when "#" then process_damaged(springs, group_sizes, memo)
    else group_sizes.empty? ? 1 : 0
    end
end

def branch_for_unknown(springs, group_sizes, memo)
  SUBSTITUTIONS
    .each_char
    .sum { |sub| memoized_count(sub + springs[1..], group_sizes, memo) }
end

def process_damaged(springs, group_sizes, memo)
  return 0 if group_sizes.empty?

  damaged_len = springs.chars.take_while { |c| DAMAGED_CHARS.include? c }.size
  curr_group = group_sizes.first

  if damaged_len < curr_group || springs[curr_group] == "#"
    0
  elsif springs.size == curr_group
    memoized_count("", group_sizes[1..], memo)
  else
    memoized_count(springs[(curr_group + 1)..], group_sizes[1..], memo)
  end
end

UNFOLD_CONST = 5
Record = Data.define(:springs, :group_sizes) do
  def count_arrangements = memoized_count(springs, group_sizes)

  def unfold
    unfolded_springs = ([springs] * UNFOLD_CONST).join("?")
    unfolded_group_sizes = group_sizes * UNFOLD_CONST
    Record[springs: unfolded_springs, group_sizes: unfolded_group_sizes]
  end
end

input = ARGF.readlines(chomp: true).map(&:split)
condition_records = input.map do |springs, group_sizes|
  Record[springs:, group_sizes: group_sizes.split(",").map(&:to_i)]
end

p condition_records.sum(&:count_arrangements) # p1

p condition_records.map(&:unfold).sum(&:count_arrangements) # p2
