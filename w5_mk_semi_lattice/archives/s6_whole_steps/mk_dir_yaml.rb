require 'yaml'
require 'optparse'

options = { layer: 2 }
OptionParser.new do |opts|
  opts.banner = "Usage: ruby mk_dir_yaml.rb PATH [-L layer]"
  opts.on("-L N", Integer, "Layer depth (default: 2)") { |v| options[:layer] = v }
end.parse!

path = ARGV[0] || '.'
abs_path = File.expand_path(path)
root_key = File.basename(abs_path) + '/'  # 末尾に'/'を追加

def dir_tree(path, depth)
  return nil if depth < 0
  tree = {}
  Dir.children(path).each do |entry|
    next if entry.start_with?('.') # 隠しファイル・ディレクトリは除外
    full = File.join(path, entry)
    if File.symlink?(full)
      target = File.readlink(full)
      tree[entry] = "-> #{target}"
    elsif File.directory?(full)
      subtree = dir_tree(full, depth - 1)
      if subtree
        tree["#{entry}/"] = subtree
      else
        tree["#{entry}/"] = nil
      end
    else
      tree[entry] = nil
    end
  end
  tree
end

result = { root_key => dir_tree(path, options[:layer] - 1) }
p result
File.write("dir.yaml", result.to_yaml)
puts "Directory structure exported to dir.yaml"
