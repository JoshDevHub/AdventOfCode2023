input = ARGF.readlines.map { |line| line.split.map(&:to_i) }

def predict(numbers)
  return 0 if numbers.all?(&:zero?)

  next_line = numbers.each_cons(2).map { |a, b| b - a }
  yield(numbers, next_line)
end

pre = ->(nums, line) { nums.first - predict(line, &pre) }
post = ->(nums, line) { nums.last + predict(line, &post) }

p(input.sum { predict(_1, &pre) }) # p1

p(input.sum { predict(_1, &post) }) # p2
