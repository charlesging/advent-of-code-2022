class InputParser
  def self.parse(input)
    matrix = []
    File.readlines(input, chomp: true).each do |line|
      matrix << line.chars.map(&:to_i)
    end
    matrix
  end
end


class TreeSurvey
  def initialize(trees)
    @trees = trees
  end

  def perimeter_tree_count
    top_bottom = trees[0].length * 2
    left_right = top_bottom - 4
    top_bottom + left_right
  end

  # PART 1
  def visible_trees
    visibile_tree_count = 0

    # 🥴
    1.upto(trees.length - 2) do |row_idx|
      1.upto(trees[row_idx].length - 2) do |col_idx|
        current_tree = trees[row_idx][col_idx]

        trees_above = trees.map.with_index { |row, row_idx2| row[col_idx] if row_idx2 < row_idx }.compact
        trees_below = trees.map.with_index { |row, row_idx2| row[col_idx] if row_idx2 > row_idx }.compact
        trees_left = trees[row_idx].slice(0...col_idx)
        trees_right = trees[row_idx].slice(col_idx + 1..-1)

        current_tree_visible = [trees_above, trees_below, trees_left, trees_right].any? do |trees|
          trees.all? { |tree| tree < current_tree }
        end

        visibile_tree_count += 1 if current_tree_visible
      end
    end

    visibile_tree_count + perimeter_tree_count
  end

  # PART 2
  def most_scenic_tree_score
    # 🥴
    max_scenic_score = 0
    1.upto(trees.length - 2) do |row_idx|
      1.upto(trees[row_idx].length - 2) do |col_idx|
        current_tree = trees[row_idx][col_idx]

        trees_above = trees.map.with_index { |row, row_idx2| row[col_idx] if row_idx2 < row_idx }.compact.reverse
        trees_below = trees.map.with_index { |row, row_idx2| row[col_idx] if row_idx2 > row_idx }.compact
        trees_left = trees[row_idx].slice(0...col_idx).reverse
        trees_right = trees[row_idx].slice(col_idx + 1..-1)

        direction_scores = [trees_above, trees_left, trees_below, trees_right].map do |trees|
          scores = 0
          trees.each do |tree|
            scores += 1
            break if tree >= current_tree
          end
          scores
        end

        current_scenic_score = direction_scores.reduce(&:*)
        max_scenic_score = current_scenic_score if current_scenic_score > max_scenic_score
      end
    end

    max_scenic_score
  end

  private

  attr_reader :trees
end

trees = InputParser.parse('./input.txt')
survey = TreeSurvey.new(trees)
survey.visible_trees
survey.most_scenic_tree_score