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

empty_grid = create_grid('./input.txt')
