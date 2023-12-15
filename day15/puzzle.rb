def hash(string, offset = 0)
  string.each_char.reduce(offset) do |code, char|
    (((code + char.ord) * 17) % 256)
  end
end

input = ARGF.read.chomp.split(",")

p(input.sum { |seq| hash(seq) }) # p1

Lens = Struct.new(:label, :focal_len) do
  def set_len(new_len) = self.focal_len = new_len
end

boxes = {}
input.each do |seq|
  label, focal_len = seq.split(/=|-/)
  focal_len = focal_len.to_i
  key = hash(label) + 1

  boxes[key] ||= []
  if seq.include?("-")
    boxes[key].reject! { |lens| lens.label == label }
    next
  end

  found = boxes[key].find { |lens| lens.label == label }
  found&.set_len(focal_len) || boxes[key] << Lens.new(label, focal_len)
end

focus_power = boxes.sum do |box_num, lens_list|
  lens_list.each_with_index.sum { |lens, i| box_num * (i + 1) * lens.focal_len }
end

p focus_power # p2
