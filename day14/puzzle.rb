VALUES = %w[# O .].freeze

Space = Data.define(:char) do
  def round_rock? = char == "O"
  def cube_rock? = char == "#"
  def empty? = char == "."
  def value = VALUES.index(char)
  def reverse_value = VALUES.reverse.index(char)
end

input = ARGF.readlines(chomp: true).map { |line| line.chars.map { Space[char: _1] } }

def calculate_north_load(data)
  data.transpose.sum do |col|
    col.each_with_index.sum { |s, i| s.round_rock? ? col.length - i : 0 }
  end
end

ROLL_DOWN = ->(row) { row.slice_before(&:cube_rock?).flat_map { |g| g.sort_by(&:value) } }
ROLL_UP = ->(row) { row.slice_after(&:cube_rock?).flat_map { |g| g.sort_by(&:reverse_value) } }

def tilt(data, &block) = data.map(&block)
def tilt_north(data) = tilt(data.transpose, &ROLL_DOWN).transpose
def tilt_west(data) = tilt(data, &ROLL_DOWN)
def tilt_south(data) = tilt(data.transpose, &ROLL_UP).transpose
def tilt_east(data) = tilt(data, &ROLL_UP)

def cycle(data)
  tilt_north(data)
    .then { tilt_west _1 }
    .then { tilt_south _1 }
    .then { tilt_east _1 }
end

# p1
p tilt_north(input)
  .then { calculate_north_load _1 }

def calculate_early_end(cycle_start, cycle_end, n = 1_000_000_000)
  captured_in_cycle = n - cycle_start
  cycle_len = cycle_end - cycle_start
  end_cycle_pos = captured_in_cycle % cycle_len
  cycle_end + end_cycle_pos
end

cycle_count = 0
cache = {}
exit_cycle = -1
spin_cycle_data = input

loop do
  break if cycle_count == exit_cycle

  spin_cycle_data = cycle(spin_cycle_data)
  key = spin_cycle_data.map(&:join).join("\n")
  exit_cycle = calculate_early_end(cache[key], cycle_count) if cache.key?(key) && exit_cycle.negative?

  cache[key] = cycle_count
  cycle_count += 1
end

p calculate_north_load(spin_cycle_data) # p2
