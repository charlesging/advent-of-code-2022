# https://adventofcode.com/2022/day/9

require 'pry'

def create_grid(input)
  max_rows_idx = 0
  max_cols_idx = 0
  current_row_idx = 0
  current_col_idx = 0
 
  File.readlines(input, chomp: true).each do |line|
    direction, spaces = line.split(' ')
    spaces = spaces.to_i

    if direction == 'R'
      current_col_idx += spaces
      if current_col_idx > max_cols_idx
        max_cols_idx = current_col_idx
      end
    elsif direction == 'L'
      current_col_idx -= spaces
      if current_col_idx.negative?
        max_cols_idx += current_col_idx.abs
        current_col_idx = 0
      end
    elsif direction == 'U'
      current_row_idx -= spaces
      if current_row_idx.negative?
        max_rows_idx += current_row_idx.abs
        current_row_idx = 0
      end
    else # 'D'
      current_row_idx += spaces
      if current_row_idx > max_rows_idx
        max_rows_idx = current_row_idx
      end
    end
  end

  Array.new(max_rows_idx + 1) { Array.new(max_cols_idx + 1, 0) }
end

class Location
  attr_accessor :row, :col

  def initialize(row, col)
    @row = row
    @col = col
  end

  def move(new_row, new_col)
    self.row = new_row
    self.col = new_col
  end

  def adjacent?(other)
    horizontally_adjacent?(other) ||
      vertically_adjacent?(other) ||
      diagonally_adjacent?(other)
  end

  def diagonally_adjacent?(other)
    return false unless !same_row?(other) && !same_col?(other)

    col_diff = (col - other.col).abs
    row_diff = (row - other.row).abs
    [col_diff, row_diff].all? { |diff| diff == 1 }
  end

  def horizontally_adjacent?(other)
    same_row?(other) && (col - other.col).abs == 1
  end

  def vertically_adjacent?(other)
    same_col?(other) && (row - other.row).abs == 1
  end

  def same_row?(other)
    row == other.row
  end

  def same_col?(other)
    col == other.col
  end
end

class RopeBridge
  attr_reader :grid, :instructions, :head, :tail, :spaces_visited

  def initialize(empty_grid, instructions)
    @grid = empty_grid
    @instructions = instructions
    @head = Location.new(grid.length - 1, 0)
    @tail = Location.new(head.row, head.col)
    @spaces_visited = [[grid.length - 1, 0]]
  end

  def process_moves
    moves.each do |direction, times|
      times.times do
        case direction
        when 'U'
          head.move(head.row - 1, head.col)
        when 'D'
          head.move(head.row + 1, head.col)
        when 'R'
          head.move(head.row, head.col + 1)
        when 'L'
          head.move(head.row, head.col - 1)
        end

        if !head.adjacent?(tail)
          if head.same_row?(tail)
            adjust_tail_col
          elsif head.same_col?(tail)
            adjust_tail_row
          else
            if ['U', 'D'].include? direction
              tail.col = head.col
              adjust_tail_row
            else # L / R
              tail.row = head.row
              adjust_tail_col
            end
          end

          spaces_visited << [tail.row, tail.col]
        end
      end
    end
  end

  def num_uniq_spaces_visited
    spaces_visited.uniq.count
  end

  private

  def adjust_tail_col
    tail.move(tail.row, tail.col -= 1) if head.col < tail.col
    tail.move(tail.row, tail.col += 1) if head.col > tail.col
  end

  def adjust_tail_row
    tail.move(tail.row -= 1, tail.col) if head.row < tail.row
    tail.move(tail.row += 1, tail.col) if head.row > tail.row
  end

  def moves
    File.readlines(instructions, chomp: true).map do |line|
      direction, times = line.split(' ')
      [direction, times.to_i]
    end
  end
end

empty_grid = create_grid('./input.txt')
bridge = RopeBridge.new(empty_grid, './input.txt')
bridge.process_moves
bridge.spaces_visited.uniq.count
bridge.num_uniq_spaces_visited

