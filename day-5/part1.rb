# https://adventofcode.com/2022/day/5

class InputParser
  attr_reader :raw_input, :total_stacks, :stack_mapping, :stacks

  def initialize
    @raw_input = File.readlines('./src/input.txt', chomp: true)
    @total_stacks = determine_total_stacks
    @stack_mapping = build_stack_mapping
    @stacks = build_initial_stacks
  end

  def instructions
    raw = raw_input.slice(stack_numbers_line_index + 2..-1)
    raw.map do |line|
      # amount, from, to
      line.scan(/\d/).map(&:to_i) # parsing ints should live in consuming class
    end
  end

  def build_initial_stacks
    stacks = Hash.new { |h, k| h[k] = [] }

    boxes_lines.reverse.each do |line|
      stack_mapping.each_key do |idx|
        if line[idx] && line[idx] != ' '
          stack = stack_mapping[idx]
          stacks[stack] << line[idx]
        end
      end
    end
    stacks
  end

  def stack_numbers_line_index
    @stack_numbers_line_index ||= raw_input.index(stack_numbers_line)
  end

  def boxes_lines
    raw_input.slice(0...stack_numbers_line_index)
  end

  def stack_numbers_line
    raw_input.find { |line| line.match /\d/ }
  end

  def determine_total_stacks
    stack_numbers_line.split(' ').last.to_i
  end

  def build_stack_mapping
    result = {}
    idx = 1
    @total_stacks.times do |n|
      result[idx] = n + 1
      idx += 4
    end
    result
  end
end

parser = InputParser.new
stacks_hash = parser.stacks
p parser.stack_numbers_line_index
instructions = parser.instructions

# p instructions[0...10]

class Crane
  attr_reader :stacks_hash, :instructions

  def initialize(stacks_hash, instructions)
    @stacks_hash = stacks_hash
    @instructions = instructions
  end

  def make_moves
    # instructions: amount, from, to
    # from / to refer to key in stacks_hash

    # iterate through instructions.
    # for each instruction, 
      # amount times: 
        # pop a value from the value arr referenced by the from key
        # append this value to the value arr referenced by the to key
    instructions.each do |times, from, to|
      p stacks_hash
      times.times do
        val = stacks_hash[from].pop
        stacks_hash[to] << val if val
        # stacks_hash
      end
    end
    stacks_hash
  end

  def top_crates
    stacks_hash.values.map(&:last).join
  end
end

crane = Crane.new(stacks_hash, instructions)
# p crane.top_crates
# p stacks_hash
crane.make_moves
p crane.top_crates


# TMJPHBF wrong