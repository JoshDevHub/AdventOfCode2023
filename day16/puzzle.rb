MOVEMENTS = {
  up: [-1, 0], down: [1, 0], left: [0, -1], right: [0, 1]
}.freeze

Laser = Data.define(:direction, :row, :col) do
  def in_bounds?(max_row, max_col)
    row >= 0 && col >= 0 && row < max_row && col < max_col
  end

  def move_laser(direction)
    new_row, new_col = MOVEMENTS[direction].zip([row, col]).map(&:sum)
    Laser[direction:, row: new_row, col: new_col]
  end
end

class Tile
  attr_reader :char, :energized
  alias energized? energized

  def initialize(char)
    @char = char
    @energized = false
    @dir_visit = Set.new
  end

  CHAR_MAP = {
    "/" => { up: [:right], left: [:down], right: [:up], down: [:left] },
    "\\" => { down: [:right], left: [:up], right: [:down], up: [:left] },
    "-" => { left: [:left], right: [:right], up: %i[left right], down: %i[left right] },
    "|" => { up: [:up], down: [:down], left: %i[up down], right: %i[up down] }
  }.freeze

  def visited_by_dir?(direction) = @dir_visit.include?(direction)

  def add_visit(direction)
    @dir_visit << direction
    @energized = true
  end

  def direct_laser(direction)
    (char == ".") ? [direction] : CHAR_MAP[char][direction]
  end
end

input = File.readlines(ARGV[0], chomp: true)
ROW_LEN = input.length
COL_LEN = input[0].length

def fire_laser(file_input, row:, col:, direction:)
  tiles = file_input.map { |line| line.each_char.map { Tile.new _1 } }

  lasers_queue = [Laser[direction:, row:, col:]]
  until lasers_queue.empty?

    curr_laser = lasers_queue.pop
    curr_tile = tiles[curr_laser.row][curr_laser.col]
    next if curr_tile.visited_by_dir?(curr_laser.direction)

    curr_tile.add_visit(curr_laser.direction)

    directions = curr_tile.direct_laser(curr_laser.direction)
    directions.each do |dir|
      next_laser = curr_laser.move_laser(dir)
      next unless next_laser.in_bounds?(ROW_LEN, COL_LEN)

      lasers_queue << next_laser
    end
  end
  tiles.flatten.count(&:energized?)
end

p fire_laser(input, row: 0, col: 0, direction: :right) # p1

max_energy = lambda do |row, col, direction, max|
  curr_energy = fire_laser(input, row:, col:, direction:)
  [max, curr_energy].max
end

p [
  (0...ROW_LEN).reduce(0) { |max, curr| max_energy[curr, 0, :right, max] },
  (0...ROW_LEN).reduce(0) { |max, curr| max_energy[curr, COL_LEN - 1, :left, max] },
  (0...COL_LEN).reduce(0) { |max, curr| max_energy[0, curr, :down, max] },
  (0...COL_LEN).reduce(0) { |max, curr| max_energy[ROW_LEN - 1, curr, :up, max] }
].max
