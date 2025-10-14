require 'optparse'
require 'yaml'

options = { depth: Float::INFINITY }
OptionParser.new do |opts|
  opts.on('-L N', Integer, 'Max depth') { |n| options[:depth] = n }
end.parse!

def dir_to_array(path, max_depth, current_depth = 0)
  return [] if current_depth >= max_depth
  Dir.children(path).sort.reject { |entry| entry.start_with?('.') }.map do |entry|
    full_path = File.join(path, entry)
    if File.directory?(full_path)
      { entry => dir_to_array(full_path, max_depth, current_depth + 1) }
    else
      entry
    end
  end
end

root = ARGV[0] || '.'
root_name = File.basename(File.expand_path(root))
# root_nameをトップレベルのキーにして階層構造を作る
result = [{ root_name => dir_to_array(root, options[:depth]) }]

p result

File.open('directories.yaml', 'w') do |f|
  f.write(result.to_yaml)
end

puts "Saved directory structure to directories.yaml"
# Usage: ruby mk_dir_array.rb [options] [path]
# Options:
#   -L N    Max depth (default: infinite)