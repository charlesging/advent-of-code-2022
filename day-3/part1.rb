# https://adventofcode.com/2022/day/3

PRIORITY_VALUES = (('a'..'z').to_a + ('A'..'Z').to_a).each_with_index.map { |char, idx| [char, idx + 1] }.to_h

class InputParser
  def self.parse
    File.readlines('./src/input.txt', chomp: true)
  end
end

module Helpers
  def string_similarites(s1, s2)
    # assumes a single intersection
    s1.chars.intersection(s2.chars).first
  end
end

class RuckSack
  attr_reader :pocket1, :pocket2

  def initialize(all_contents)
    @pocket1, @pocket2 = all_contents.chars.each_slice(all_contents.length / 2).map(&:join)
  end
end

class SumPrioritiesCalculator
  include Helpers
  attr_reader :rucksacks

  def initialize(rucksacks)
    @rucksacks = rucksacks
  end

  def calculate
    similarities = rucksacks.map { |sack| string_similarites(sack.pocket1, sack.pocket2) }
    similarities.reduce(0) do |sum, similarity|
      sum + PRIORITY_VALUES[similarity]
    end
  end
end

input = InputParser.parse
rucksacks = input.map { |contents| RuckSack.new(contents) }

SumPrioritiesCalculator.new(rucksacks).calculate # => 7746
