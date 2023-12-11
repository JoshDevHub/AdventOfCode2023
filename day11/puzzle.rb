sky_map = ARGF.readlines(chomp: true).map(&:chars)

EMPTY_ROWS = sky_map.filter_map.with_index do |row, i|
  i if row.all?(".")
end

EMPTY_COLS = sky_map.transpose.filter_map.with_index do |col, i|
  i if col.all?(".")
end

galaxies = []
sky_map.each_with_index do |row, row_i|
  row.each_with_index { |char, col| galaxies << [row_i, col] if char == "#" }
end

def man_dist(row, col, other_row, other_col)
  (row - other_row).abs + (col - other_col).abs
end

def distance_between_pair(pair, empty_factor = 1)
  pair => [row, col], [other_row, other_col]

  col_count = EMPTY_COLS.count { |c| c.between?([other_col, col].min, [other_col, col].max) }
  row_count = EMPTY_ROWS.count { |r| r.between?([other_row, row].min, [other_row, row].max) }
  total_empties = col_count + row_count

  man_dist(row, col, other_row, other_col) + (total_empties * empty_factor)
end

# p1
p galaxies
  .combination(2)
  .flat_map { |pair| distance_between_pair(pair) }
  .sum

# p2
p galaxies
  .combination(2)
  .flat_map { |pair| distance_between_pair(pair, 999_999) }
  .sum
