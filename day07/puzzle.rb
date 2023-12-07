class Hand
  attr_reader :cards, :bid

  CARD_VALUES = %w[2 3 4 5 6 7 8 9 T J Q K A].map.with_index { [_1, _2] }.to_h
  TYPE_VALUES = %i[
    high one_pair two_pair three_of_kind full_house four_of_kind five_of_kind
  ].map.with_index { [_1, _2] }.to_h

  def initialize(cards:, bid: 0)
    @cards = cards
    @bid = bid
  end

  def type_value = TYPE_VALUES[type]
  def card_ranks = cards.map(&self.class::CARD_VALUES)
  def tally = cards.tally.values.sort.reverse

  def type
    case tally
    in [5] then :five_of_kind
    in 4, _ then :four_of_kind
    in 3, 2 then :full_house
    in 3, * then :three_of_kind
    in 2, 2, _ then :two_pair
    in 2, * then :one_pair
    else :high
    end
  end
end

class JokerHand < Hand
  CARD_VALUES = %w[J 2 3 4 5 6 7 8 9 T Q K A].map.with_index { [_1, _2] }.to_h
  JOKER = "J".freeze

  def type_value
    return super unless cards.include?(JOKER)

    new_hands = CARD_VALUES.keys.reject { |k| k == JOKER }.map do |val|
      Hand.new(cards: cards.join.tr(JOKER, val).chars).type
    end

    new_hands.map(&TYPE_VALUES).max
  end
end

hands = ARGF
        .readlines
        .map(&:split)
        .map { |cards, bids| Hand.new(cards: cards.chars, bid: bids.to_i) }

def calculate_winnings(hands)
  hands
    .sort_by { |hand| [hand.type_value, *hand.card_ranks] }
    .each_with_index
    .sum { |hand, i| hand.bid * (i + 1) }
end

p calculate_winnings(hands) # p1

joker_hands = hands.map { |hand| JokerHand.new(cards: hand.cards, bid: hand.bid) }
p calculate_winnings(joker_hands) # p2
