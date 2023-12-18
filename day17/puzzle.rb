require "rb_heap"

input = ARGF.readlines(chomp: true)

ROW_LEN = input.length
COL_LEN = input[0].length

Point = Data.define(:row, :col) do
  def +(other) = Point[row + other.row, col + other.col]
  def *(other) = Point[row * other, col * other]
  def valid? = row >= 0 && col >= 0 && row < ROW_LEN && col < COL_LEN
end

DIRS = {
  u: Point[-1, 0], d: Point[1, 0], l: Point[0, -1], r: Point[0, 1]
}.freeze
RECIPROCAL_MAP = { u: :d, d: :u, l: :r, r: :l }.freeze

Node = Data.define(:point, :from_dir, :total_heat) do
  def id = [point, from_dir]
end

graph = input.map { |row| row.each_char.map(&:to_i) }

class Dijkstra
  def initialize(graph, min:, max:)
    @q = Heap.new { |a, b| a.total_heat < b.total_heat }
    @seen = Set.new
    @heats = Hash.new(Float::INFINITY)
    @graph = graph
    @target = Point[ROW_LEN - 1, COL_LEN - 1]
    @min = min
    @max = max
  end

  def search
    @q << Node[point: Point[0, 0], from_dir: nil, total_heat: 0]
    loop do
      curr_node = @q.pop
      return curr_node.total_heat if curr_node.point == @target
      next if @seen.include?(curr_node.id)

      @seen << curr_node.id
      enq_adjacents(curr_node)
    end
  end

  def enq_adjacents(curr_node)
    DIRS.each do |dir_name, dir_point|
      next if [dir_name, RECIPROCAL_MAP[dir_name]].include?(curr_node.from_dir)

      enq_in_distance(curr_node, dir_name, dir_point)
    end
  end

  def enq_in_distance(curr_node, dir_name, dir_point)
    heat_inc = 0
    (1..@max).each do |dist|
      new_point = curr_node.point + (dir_point * dist)
      next unless new_point.valid?

      heat_inc += @graph[new_point.row][new_point.col]
      next if dist < @min

      new_heat = curr_node.total_heat + heat_inc
      candidate = Node[point: new_point, from_dir: dir_name, total_heat: new_heat]
      next if @heats[candidate.id] <= new_heat

      @heats[candidate.id] = new_heat
      @q << candidate
    end
  end
end

p Dijkstra.new(graph, min: 1, max: 3).search

p Dijkstra.new(graph, min: 4, max: 10).search
