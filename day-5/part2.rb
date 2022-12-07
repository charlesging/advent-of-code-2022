require_relative 'part1'

class Crane9001 < Crane9000
  def make_moves
    instructions.each do |quantity, from, to|
      if quantity > stacks_hash[from].size
        quantity = stacks_hash[from].size
      end

      pickup = stacks_hash[from].slice!(-quantity..-1)
      stacks_hash[to] += pickup
    end
  end
end

parser = InputParser.new
crane = Crane9001.new(parser.stacks, parser.instructions)
crane.make_moves
crane.top_crates # RWLWGJGFD
