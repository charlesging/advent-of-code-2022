require_relative 'part1'

food_per_elf = InputParser.food_per_elf
top_three_elves = food_per_elf.slice(0, 3)

food_per_elf.each do |calories|
  top_three_elves.sort_by! { |arr| arr.reduce(:+) }
  current_total_cals = calories.reduce(:+)

  top_three_elves[0] = calories if current_total_cals > top_three_elves[0].reduce(:+)
end

top_three_elves.reduce(0) { |sum, arr| sum + arr.reduce(:+) }
