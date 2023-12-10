CHAR_MAP = {
  "|" => { north: :north, south: :south },
  "-" => { east: :east, west: :west },
  "L" => { south: :east, west: :north },
  "J" => { east: :north, south: :west },
  "7" => { north: :west, east: :south },
  "F" => { north: :east, west: :south }
}.freeze

DIRECTIONS = {
  north: ->(r, c) { [r - 1, c] },
  south: ->(r, c) { [r + 1, c] },
  east: ->(r, c) { [r, c + 1] },
  west: ->(r, c) { [r, c - 1] }
}.freeze

Pipe = Data.define(:char) do
  def travel(from:) = CHAR_MAP[char].fetch(from)
  def enter?(dir) = CHAR_MAP[char].key?(dir)
  def s_char? = char == "S"
end

pipe_maze = ARGF.readlines(chomp: true).map do |row|
  row.chars.map { |char| Pipe.new(char) }
end

s_row = pipe_maze.find_index { |row| row.any?(&:s_char?) }
s_col = pipe_maze[s_row].find_index(&:s_char?)
dir, move = DIRECTIONS.find do |dir, fn|
  adj_row, adj_col = fn[s_row, s_col]
  pipe_maze[adj_row][adj_col].enter?(dir)
end.to_a

curr = { pos: move[s_row, s_col], dir: }
step_count = 1
loop do
  row, col = curr[:pos]
  break if pipe_maze[row][col].s_char?

  next_dir = pipe_maze[row][col].travel(from: curr[:dir])
  next_pos = DIRECTIONS[next_dir][row, col]

  curr = { pos: next_pos, dir: next_dir }
  step_count += 1
end

p step_count / 2
