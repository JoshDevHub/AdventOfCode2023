class Node
  attr_reader :value, :left, :right

  def self.registry = @registry ||= {}

  def initialize(value:, left: nil, right: nil)
    @value = value
    @left = left
    @right = right
  end

  def travel(direction)
    Node.registry[(direction == "L") ? @left : @right]
  end
end

dirs, node_data = ARGF.read.split("\n\n")

node_data.split("\n").each do |datum|
  parent, children = datum.split(" = ")
  left, right = children.scan(/[A-Z]+/)
  Node.registry[parent] = Node.new(value: parent, left:, right:)
end

current_node = Node.registry["AAA"]
steps = dirs.chars.cycle.with_index do |dir, i|
  current_node = current_node.travel(dir)

  break(i) if current_node.value == "ZZZ"
end
p steps # p1

a_ending_nodes = Node.registry.values.select { |node| node.value.end_with?("A") }

first_z_endings = a_ending_nodes.map do |node|
  dirs.chars.cycle.with_index do |dir, i|
    node = node.travel(dir)
    break(i + 1) if node.value.end_with?("Z")
  end
end

p first_z_endings.reduce(:lcm) # p2
