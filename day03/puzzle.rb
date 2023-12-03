EnginePart = Data.define(:char) do
  def numeric? = /\d/.match?(char)
  def symbol? = !numeric? && char != "."
  def possible_gear? = char == "*"
  def to_s = char.to_s
  def hash = object_id
end

input = File
        .readlines(ARGV[0], chomp: true)
        .map { |line| line.chars.map { |char| EnginePart.new char } }

ROW_LEN = input.length
COL_LEN = input[0].length
def valid_coord?(row, col)
  row >= 0 && col >= 0 && row < ROW_LEN && col < COL_LEN
end

def find_adjacents(right, left, row_num)
  above_and_below = [row_num + 1, row_num - 1].product([*(left - 1)..(right + 1)])

  [*above_and_below, [row_num, left - 1], [row_num, right + 1]]
    .select { |coord| valid_coord?(*coord) }
end

part_numbers = []
gears = {}

input.each_with_index do |row, row_num|
  left = 0
  right = 0

  while left < COL_LEN
    if row[left].numeric?
      right += 1 while right + 1 < COL_LEN && row[right + 1].numeric?

      adjs = find_adjacents(right, left, row_num).map { |r, c| input[r][c] }
      current_number = row[left..right].join.to_i
      part_numbers << current_number if adjs.any?(&:symbol?)

      possible_gears = adjs.select(&:possible_gear?)
      possible_gears.each do |possibility|
        gears[possibility] ||= []
        gears[possibility] << current_number
      end
    end

    right += 1
    left = right
  end
end

p part_numbers.sum # p1

p(
  gears
    .values
    .select { |g| g.size == 2 }
    .sum { |g| g.first * g.last }
) # p2
