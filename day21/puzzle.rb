input = ARGF.readlines(chomp: true).map(&:chars)

ROW_LEN = input.length
COL_LEN = input[0].length
DIRS = [[1, 0], [-1, 0], [0, 1], [0, -1]].freeze

def valid_pos?(row, col)
  row.between?(0, ROW_LEN - 1) && col.between?(0, COL_LEN - 1)
end

def get_adjs(pos)
  pr, pc = pos
  DIRS.filter_map do |dr, dc|
    row = pr + dr
    col = pc + dc
    next unless valid_pos?(row, col)

    [row, col]
  end
end

start_row = input.index { |r| r.include?("S") }
start_col = input[start_row].index { |char| char == "S" }

positions = [[start_row, start_col]]
64.times do
  new_positions = []

  positions.each do |position|
    adjs = get_adjs(position)
    new_positions += adjs.reject { |r, c| input[r][c] == "#" }
  end

  new_positions.uniq!
  positions = new_positions
end
p positions.size # p1
