Cube = Data.define(:total, :color)

class Game
  attr_reader :id

  def initialize(id:, rounds:)
    @id = id
    @rounds = rounds
  end

  MAXIMUM_VALUES = { "red" => 12, "green" => 13, "blue" => 14 }.freeze
  COLORS = %w[red green blue].freeze

  def power = COLORS.map { |c| min_amount_needed_for(c) }.reduce(:*)

  def min_amount_needed_for(color)
    @rounds.select { |cube| cube.color == color }.map(&:total).max
  end

  def possible?
    @rounds.all? { |cube| cube.total <= MAXIMUM_VALUES[cube.color] }
  end
end

input = File.readlines(ARGV[0], chomp: true)

games = input.map do |line|
  id_section, round_section = line.split(": ")
  id = id_section.scan(/\d+/).first.to_i
  rounds = round_section.split(/;\s|,\s/).map do |cube_details|
    total, color = cube_details.split
    Cube.new(total: total.to_i, color:)
  end

  Game.new(id:, rounds:)
end

p games.select(&:possible?).sum(&:id) # p1

p games.sum(&:power) # p2
