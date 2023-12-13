class String
  def one_diff?(other)
    diff_count = each_char.with_index.count { |char, i| char != other[i] }
    diff_count == 1
  end
end

def find_mirror_idx(pattern, &diff_fn)
  stack = [pattern.first]

  pattern.each_with_index do |row, idx|
    next if idx.zero?

    remaining = pattern[idx..].reverse
    reflect_size = [stack.size, remaining.size].min
    return idx if diff_fn[
      stack.last(reflect_size).join,
      remaining.last(reflect_size).join
    ]

    stack << row
  end
  nil
end

patterns = ARGF.read.split("\n\n").map { |pattern| pattern.split.map(&:chars) }

ROW_MULTIPLIER = 100
total = patterns.sum do |pattern|
  eq_check = ->(top, bottom) { top == bottom }
  col_idx = find_mirror_idx(pattern.transpose, &eq_check)
  col_idx || find_mirror_idx(pattern, &eq_check) * ROW_MULTIPLIER
end
p total # p1

smudged_total = patterns.sum do |pattern|
  one_diff = ->(top, bottom) { top.one_diff?(bottom) }
  col_idx = find_mirror_idx(pattern.transpose, &one_diff)
  col_idx || find_mirror_idx(pattern, &one_diff) * ROW_MULTIPLIER
end
p smudged_total # p2
