# https://adventofcode.com/2022/day/4

class InputParser
  def self.parse
    lines = File.readlines('./src/input.txt', chomp: true)
    lines.map do |zone_ranges|
      range1, range2 = zone_ranges.split(',')
      range1 = Range.new(*range1.split('-')).to_a.map(&:to_i)
      range2 = Range.new(*range2.split('-')).to_a.map(&:to_i)

      [range1, range2]
    end
  end
end

lines = InputParser.parse
count = 0

# PART 1

lines.count do |range1, range2|
  if range1.all? { |n| range2.include? n } ||
     range2.all? { |n| range1.include? n }
    count += 1
  end
end

p count # 599

# PART 2

count = 0

lines.count do |range1, range2|
  if range1.any? { |n| range2.include? n } ||
     range2.any? { |n| range1.include? n }
    count += 1
  end
end

p count # 928
