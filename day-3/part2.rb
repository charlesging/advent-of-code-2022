require_relative 'part1'

raw_input = InputParser.parse
groups_of_three = raw_input.each_slice(3).to_a


def common_items(groups_of_three)
  groups_of_three.map do |sack1, sack2, sack3|
    find_common_item(sack1, sack2, sack3)
  end
end

def find_common_item(sack1, sack2, sack3)
  sack1.chars.each do |char|
    # assumes group size of 3
    return char if sack2.include?(char) && sack3.include?(char)
  end
end

def priority_sum(groups_of_three)
  common_items(groups_of_three).reduce(0) do |sum, common_item|
    sum + PRIORITY_VALUES[common_item]
  end
end

priority_sum(groups_of_three) # 2604
