# head
date: 2025-10-18
author: bob

## User
PATHをARGV[0]で受け取って，-L 2などのoptionを受け取って，PATH配下layer 2層分のdirectory構造をdir.yamlに出力するRubyスクリプトを作成してください．


[dir_exporter.rb](./codes/nowledge_fixer.rb)

作成するRubyスクリプトの手順:
1. コマンドライン引数でPATHとオプション（例: `-L 2`）を受け取る。
2. 指定されたPATH配下のディレクトリ構造を、指定された層数（デフォルト2層）分だけ再帰的に取得。
3. ディレクトリ構造をハッシュ形式で整形し、YAMLとして`dir.yaml`に出力。

````ruby
require 'yaml'
require 'optparse'

options = { layer: 2 }
OptionParser.new do |opts|
  opts.banner = "Usage: ruby dir_exporter.rb PATH [-L layer]"
  opts.on("-L N", Integer, "Layer depth (default: 2)") { |v| options[:layer] = v }
end.parse!

path = ARGV[0]
unless path && Dir.exist?(path)
  puts "Usage: ruby dir_exporter.rb PATH [-L layer]"
  exit 1
end

def dir_tree(path, depth)
  return nil if depth < 0
  tree = {}
  Dir.children(path).each do |entry|
    full = File.join(path, entry)
    if File.directory?(full)
      subtree = dir_tree(full, depth - 1)
      tree[entry] = subtree if subtree
    else
      tree[entry] = nil
    end
  end
  tree
end

result = { File.basename(path) => dir_tree(path, options[:layer] - 1) }
File.write("dir.yaml", result.to_yaml)
puts "Directory structure exported to dir.yaml"
````

Made changes.

## User
'.'のdirectory名をkeyにしてHashを作って．

## Copilot
````ruby
# ...existing code...

path = ARGV[0] || '.'
root_key = File.expand_path(path) == File.expand_path('.') ? File.basename(Dir.pwd) : File.basename(path)

# ...existing code...

result = { root_key => dir_tree(path, options[:layer] - 1) }
# ...existing code...
````

Made changes.

## User
'..'の場合でもそのdirectory名を取得してroot_key

## Copilot
````ruby
# ...existing code...
path = ARGV[0] || '.'
abs_path = File.expand_path(path)
root_key = File.basename(abs_path)
# ...existing code...
result = { root_key => dir_tree(path, options[:layer] - 1) }
# ...existing code...
````

Made changes.

## User
directoryの時にはpath名の最後に'/'をつける．

## Copilot
````ruby
# ...existing code...

def dir_tree(path, depth)
  return nil if depth < 0
  tree = {}
  Dir.children(path).each do |entry|
    full = File.join(path, entry)
    if File.directory?(full)
      subtree = dir_tree(full, depth - 1)
      tree["#{entry}/"] = subtree if subtree
    else
      tree[entry] = nil
    end
  end
  tree
end

# ...existing code...
````

Made changes.

## User
'.'で始まる隠しファイルは入れない．symbolic linkはそのリンク先を文字列で'->' に続けて表示

## Copilot
````ruby
# ...existing code...

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
      tree["#{entry}/"] = subtree if subtree
    else
      tree[entry] = nil
    end
  end
  tree
end

# ...existing code...
````

Made changes.

## User
entryがdirectoryでも'/'を末尾につけて表示．

## Copilot
````ruby
# ...existing code...
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
      tree["#{entry}/"] = subtree if subtree
    else
      tree[entry] = nil
    end
  end
  tree
end
# ...existing code...
````

Made changes.

## User
entryがfileではなくdirectoryでも'/'を末尾につけて表示．

## Copilot
````ruby
# ...existing code...
def dir_tree(path, depth)
  return nil if depth < 0
  tree = {}
  Dir.children(path).each do |entry|
    next if entry.start_with?('.') # 隠しファイル・ディレクトリは除外
    full = File.join(path, entry)
    if File.symlink?(full)
      key = File.directory?(full) ? "#{entry}/" : entry
      target = File.readlink(full)
      tree[key] = "-> #{target}"
    elsif File.directory?(full)
      subtree = dir_tree(full, depth - 1)
      tree["#{entry}/"] = subtree if subtree
    else
      tree[entry] = nil
    end
  end
  tree
end
# ...existing code...
````

Made changes.