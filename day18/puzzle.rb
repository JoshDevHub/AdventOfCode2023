input = ARGF.readlines(chomp: true)

Point = Data.define(:row, :col) do
  def +(other) = Point[row + other.row, col + other.col]
  def *(other) = Point[row * other, col * other]
  def dist_between(other) = (row - other.row).abs + (col - other.col).abs
  def shoelace(other) = (row * other.col) - (col * other.row)
end

DIR_MAP = {
  "U" => Point[-1, 0], "D" => Point[1, 0],
  "L" => Point[0, -1], "R" => Point[0, 1]
}.freeze

dig_instructions = input.map do |line|
  dir, num, hex_code = line.tr("#)(", "").split
  { dir:, num: num.to_i, hex_code: }
end

def execute_instructions(boundary, dir, count)
  curr_point = boundary[-1]
  curr_point += DIR_MAP[dir] * count
  boundary << curr_point
end

def polygon_area(boundary)
  inner_area = boundary.reverse.each_cons(2).map { _1.shoelace _2 }.sum.div(2)
  boundary_len = boundary.each_cons(2).map { _1.dist_between _2 }.sum.div(2)
  inner_area + boundary_len + 1
end

boundary = [Point[0, 0]]
dig_instructions.each do |instr|
  instr => dir:, num:
  execute_instructions(boundary, dir, num)
end

p polygon_area(boundary)

HEX_DIR_MAP = "RDLU".freeze

hex_boundary = [Point[0, 0]]
dig_instructions.each do |instr|
  instr => hex_code:
  count = hex_code[0..4].to_i(16)
  dir = HEX_DIR_MAP[hex_code[-1].to_i]
  execute_instructions(hex_boundary, dir, count)
end

p polygon_area(hex_boundary)
