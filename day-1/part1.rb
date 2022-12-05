# https://adventofcode.com/2022/day/1
class InputParser
  def self.food_per_elf
    input_data = File.readlines('./src/input.txt') 
    input_nums = input_data.map(&:to_i)
    food_by_elf = []
    elf_food = []

    input_nums.each do |n|
      if n.zero?
        food_by_elf << elf_food
        elf_food = []
        next
      end
      elf_food << n
    end
    food_by_elf
  end
end

class MostCaloriesCalculator
  def self.calculate
    food_by_elf = InputParser.food_per_elf
    result = food_by_elf.max_by { |elf| elf.reduce(:+) }
    result.reduce(:+)
  end
end

