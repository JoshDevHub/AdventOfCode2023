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

ROW_MULTIPLIER = 100
def mirror_summary(pattern, &)
  find_mirror_idx(pattern.transpose, &) || find_mirror_idx(pattern, &) * ROW_MULTIPLIER
end

patterns = ARGF.read.split("\n\n").map { |pattern| pattern.split.map(&:chars) }

total = patterns.sum do |pattern|
  mirror_summary(pattern) { |top, bottom| top == bottom }
end
p total # p1

smudged_total = patterns.sum do |pattern|
  mirror_summary(pattern) { |top, bottom| top.one_diff?(bottom) }
end
p smudged_total # p2
