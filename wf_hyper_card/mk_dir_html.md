# head
date: 2025-10-14
author: bob

## User
directory構造を階層的なArrayに変換するRubyのfilterを作ります．-Lをオプションとして数字を引数にして深さを取るにします．

## Copilot
Rubyでディレクトリ構造を階層的なArrayに変換し、`-L` オプションで深さを指定できるfilter例です。

**使い方例:**
```sh
ruby dir_to_array.rb -L 2 /path/to/dir
```

- `-L 2` で深さ2まで取得します。
- 結果は階層的なArrayで出力されます。

## User
'.'で始まる隠しファイルは無視するようにしましょう．


## User
yaml形式で，directoreis.yamlというファイル名で保存するようにしましょう

## Copilot
````ruby
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
result = dir_to_array(root, options[:depth])

File.open('directories.yaml', 'w') do |f|
  f.write(result.to_yaml)
end

puts "Saved directory structure to directories.yaml"
# Usage: ruby mk_dir_array.rb [options] [path]
# Options:
#   -L N    Max depth (default: infinite)
````

## User
directories.yamlを読み込んで，fileやfolderアイコンで表示するhtmlを出力するfilterを作りましょう．

## User
Arrayの階層構造がそのroot_nameから始まるように変更してください

## Copilot
````ruby
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

File.open('directories.yaml', 'w') do |f|
  f.write(result.to_yaml)
end

puts "Saved directory structure to directories.yaml"
# Usage: ruby mk_dir_array.rb [options] [path]
# Options:
#   -L N    Max depth (default: infinite)
````

## User
directories.yamlのトップレベルのキーを中心のfolderにつけて，その周りにそこに属するfilesとdirectoriesのアイコンを表示するようにしてください．

## Copilot
````ruby
require 'yaml'

def array_to_circular_nodes(arr, level = 1)
  nodes = []
  arr.each_with_index do |item, idx|
    angle = 2 * Math::PI * idx / arr.size
    radius = 100 + (level - 1) * 120
    x = Math.cos(angle) * radius
    y = Math.sin(angle) * radius
    if item.is_a?(Hash)
      item.each do |folder, children|
        nodes << {
          type: :folder,
          name: folder,
          x: x,
          y: y,
          level: level,
          children: array_to_circular_nodes(children, level + 1)
        }
      end
    else
      nodes << {
        type: :file,
        name: item,
        x: x,
        y: y,
        level: level
      }
    end
  end
  nodes
end

def nodes_to_svg(nodes, parent_x, parent_y)
  svg = ""
  nodes.each do |node|
    node_x = parent_x + node[:x]
    node_y = parent_y + node[:y]
    icon = node[:type] == :folder ? "📁" : "📄"
    # 線を親から子へ
    svg << %Q(<line x1="#{parent_x}" y1="#{parent_y}" x2="#{node_x}" y2="#{node_y}" stroke="#888" stroke-width="1"/>\n)
    # アイコン
    svg << %Q(<text x="#{node_x}" y="#{node_y}" font-size="20" text-anchor="middle" alignment-baseline="middle">#{icon}</text>\n)
    # 名前
    svg << %Q(<text x="#{node_x}" y="#{node_y + 22}" font-size="12" text-anchor="middle" alignment-baseline="hanging">#{node[:name]}</text>\n)
    # 子ノード
    if node[:children]
      svg << nodes_to_svg(node[:children], node_x, node_y)
    end
  end
  svg
end

yaml_data = YAML.load_file('directories.yaml')
# トップレベルのキーとその配下を取得
if yaml_data.is_a?(Array) && yaml_data.first.is_a?(Hash)
  root_hash = yaml_data.first
else
  abort "Invalid YAML structure"
end

root_name = root_hash.keys.first
root_children = root_hash[root_name]

center_x = 400
center_y = 400

svg_content = ""
# 中心(root)のアイコンと名前
svg_content << %Q(<text x="#{center_x}" y="#{center_y}" font-size="28" text-anchor="middle" alignment-baseline="middle">📁</text>\n)
svg_content << %Q(<text x="#{center_x}" y="#{center_y + 32}" font-size="16" text-anchor="middle" alignment-baseline="hanging">#{root_name}</text>\n)

# ルート配下を同心円で描画
nodes = array_to_circular_nodes(root_children)
svg_content << nodes_to_svg(nodes, center_x, center_y)

html = <<~HTML
  <!DOCTYPE html>
  <html>
  <head>
    <meta charset="UTF-8">
    <title>Directory Structure (Circular)</title>
    <style>
      body { background: #fff; }
    </style>
  </head>
  <body>
    <svg width="800" height="800">
      #{svg_content}
    </svg>
  </body>
  </html>
HTML

File.write('directories_circular.html', html)
puts "Saved circular HTML to directories_circular.html"
````

## User
アイコンを結ぶ線がクロスしないように配置してください．

## Copilot
````ruby
require 'yaml'

# ノードを線がクロスしないように、子ノードの角度範囲を親から割り当てて再帰的に配置
def array_to_circular_nodes(arr, level = 1, angle_start = 0, angle_end = 2 * Math::PI)
  nodes = []
  count = arr.size
  return nodes if count == 0

  radius = 120 * level
  angle_step = (angle_end - angle_start) / count.to_f

  arr.each_with_index do |item, idx|
    angle = angle_start + angle_step * (idx + 0.5)
    x = Math.cos(angle) * radius
    y = Math.sin(angle) * radius
    if item.is_a?(Hash)
      item.each do |folder, children|
        # 子ノードには親の割り当てた角度範囲をさらに分割して渡す
        child_angle_start = angle_start + angle_step * idx
        child_angle_end   = angle_start + angle_step * (idx + 1)
        nodes << {
          type: :folder,
          name: folder,
          x: x,
          y: y,
          level: level,
          angle: angle,
          children: array_to_circular_nodes(children, level + 1, child_angle_start, child_angle_end)
        }
      end
    else
      nodes << {
        type: :file,
        name: item,
        x: x,
        y: y,
        level: level,
        angle: angle
      }
    end
  end
  nodes
end

def nodes_to_svg(nodes, parent_x, parent_y)
  svg = ""
  nodes.each do |node|
    node_x = parent_x + node[:x]
    node_y = parent_y + node[:y]
    icon = node[:type] == :folder ? "📁" : "📄"
    # 線を親から子へ
    svg << %Q(<line x1="#{parent_x}" y1="#{parent_y}" x2="#{node_x}" y2="#{node_y}" stroke="#888" stroke-width="1"/>\n)
    # アイコン
    svg << %Q(<text x="#{node_x}" y="#{node_y}" font-size="20" text-anchor="middle" alignment-baseline="middle">#{icon}</text>\n)
    # 名前
    svg << %Q(<text x="#{node_x}" y="#{node_y + 22}" font-size="12" text-anchor="middle" alignment-baseline="hanging">#{node[:name]}</text>\n)
    # 子ノード
    if node[:children]
      svg << nodes_to_svg(node[:children], node_x, node_y)
    end
  end
  svg
end

yaml_data = YAML.load_file('directories.yaml')
# トップレベルのキーとその配下を取得
if yaml_data.is_a?(Array) && yaml_data.first.is_a?(Hash)
  root_hash = yaml_data.first
else
  abort "Invalid YAML structure"
end

root_name = root_hash.keys.first
root_children = root_hash[root_name]

center_x = 400
center_y = 400

svg_content = ""
# 中心(root)のアイコンと名前
svg_content << %Q(<text x="#{center_x}" y="#{center_y}" font-size="28" text-anchor="middle" alignment-baseline="middle">📁</text>\n)
svg_content << %Q(<text x="#{center_x}" y="#{center_y + 32}" font-size="16" text-anchor="middle" alignment-baseline="hanging">#{root_name}</text>\n)

# ルート配下を同心円で描画（角度範囲分割でクロスしない配置）
nodes = array_to_circular_nodes(root_children)
svg_content << nodes_to_svg(nodes, center_x, center_y)

html = <<~HTML
  <!DOCTYPE html>
  <html>
  <head>
    <meta charset="UTF-8">
    <title>Directory Structure (Circular)</title>
    <style>
      body { background: #fff; }
      svg { border: 1px solid #ccc; }
    </style>
  </head>
  <body>
    <svg width="800" height="800">
      #{svg_content}
    </svg>
  </body>
  </html>
HTML

File.write('directories_circular.html', html)
puts "Saved circular HTML to directories_circular.html"
````

**ポイント**
- 各ノードの角度範囲を親から分割して割り当てることで、線がクロスしないように配置します。
- サブディレクトリも親の割り当てた角度範囲内で再帰的に配置されます。