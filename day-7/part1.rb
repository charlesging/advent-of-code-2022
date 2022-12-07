class InputParser

  def initialize(input)
    @input = input
    @directory_history = []
  end

  def generate_file_system
    file_sys = Hash.new { |hash, key| hash[key] = Hash.new(&hash.default_proc) }

    File.readlines(@input, chomp: true).each do |line|
      next if issuing_ls?(line)

      handle_line(line, file_sys)
    end

    file_sys
  end

  private

  def handle_line(line, file_sys)
    if changing_directory?(line)
      new_directory = line.slice(2..-1).split(' ').last
      handle_directory_change(new_directory)
    else
      update_file_system(file_sys, line)
    end
  end

  def handle_directory_change(new_directory)
    if new_directory == '..'
      @directory_history.pop
    else
      @directory_history << new_directory
    end
  end

  def update_file_system(file_sys, line)
    line_contents = line.split(' ')
    if line_contents[0] == 'dir'
      directory_name = line_contents[1]
      file_sys.dig(*@directory_history).merge!(directory_name => {})
    else
      file_size, file_name = line_contents
      file_sys.dig(*@directory_history).merge!(file_name => file_size.to_i)
    end
  end

  def changing_directory?(line)
    line.split(' ')[1] == 'cd'
  end

  def issuing_ls?(line)
    line.split(' ')[1] == 'ls'
  end
end

## GET FILE SIZE

def get_total_file_size(file_sys)
  dir_sizes = []
  get_total_file_size_helper(file_sys, dir_sizes)
  dir_sizes.reduce(&:+)
end

def get_total_file_size_helper(file_sys, dir_sizes)
  current_level_total =
    file_sys.reduce(0) do |total, (key, val)|
      if val.instance_of? Hash
        total + get_total_file_size_helper(file_sys[key], dir_sizes)
      else
        total + val
      end
    end

  dir_sizes << current_level_total if current_level_total <= 100_000
  current_level_total
end

parser = InputParser.new('./input.txt')
file_system_hash = parser.generate_file_system
get_total_file_size(file_system_hash) # 1453349