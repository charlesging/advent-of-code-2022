require_relative 'part1'

def get_total_used_space(file_sys)
  get_total_used_space_helper(file_sys)
end

def get_total_used_space_helper(file_sys)
  file_sys.reduce(0) do |total, (key, val)|
    if val.instance_of? Hash
      total + get_total_used_space_helper(file_sys[key])
    else
      total + val
    end
  end
end

def find_directory_to_delete(file_sys, required_space)
  qualifying_dirs = []
  find_directory_to_delete_helper(file_sys, required_space, qualifying_dirs)

  qualifying_dirs.min
end

def find_directory_to_delete_helper(file_sys, required_space, qualifying_dirs)
  current_level_total =
    file_sys.reduce(0) do |total, (key, val)|
      if val.instance_of? Hash
        total + find_directory_to_delete_helper(file_sys[key], required_space, qualifying_dirs)
      else
        total + val
      end
    end

  qualifying_dirs << current_level_total if current_level_total >= required_space
  current_level_total
end

parser = InputParser.new('./input.txt')
file_system_hash = parser.generate_file_system
total_used_space = get_total_used_space(file_system_hash)
currently_available = 70000000 - total_used_space
required_space = 30000000 - currently_available

find_directory_to_delete(file_system_hash, required_space) # 2948823