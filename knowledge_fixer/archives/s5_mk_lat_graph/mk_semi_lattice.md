daddygongon: 入力ファイルをPatternLanguage.txtからdir_node_edge.yamlに変更して，nodes, edgesを作るように修正．

GitHub Copilot: ### [mk_semi_lattice.rb](file:///Users/bob/Desktop/Lectures/MultiScale/multi_scale_25f/knowledge_fixer/archives/s5_mk_lat_graph/mk_semi_lattice.rb)

**変更内容**  
入力ファイルをdir_node_edge.yamlに変更し、YAMLからノードとエッジを生成するように修正します。  
- `require 'yaml'`を追加  
- `load_pattern_language`関数を`load_yaml_graph`に置き換え  
- デフォルトファイル名をdir_node_edge.yamlに変更

````ruby
require 'ruby2d'
require 'yaml'

# ...existing code...

def load_yaml_graph(path, nodes, edges, node_table)
  data = YAML.load_file(path)
  # ノード生成
  data['nodes'].each do |node|
    label = node['name']
    x = rand(80..520)
    y = rand(80..520)
    add_node(nodes, node_table, label, x, y)
  end
  # エッジ生成
  data['edges'].each do |edge|
    from_id = edge['from']
    to_id = edge['to']
    from_node = data['nodes'].find { |n| n['id'] == from_id }
    to_node = data['nodes'].find { |n| n['id'] == to_id }
    if from_node && to_node
      add_edge(edges, node_table, from_node['name'], to_node['name'])
    end
  end
end

# ...existing code...

file = ARGV[0] || "dir_node_edge.yaml"
load_yaml_graph(file, nodes, edges, node_table)

# ...existing code...
````

Made changes.

daddygongon: 関数名load_yaml_graphをload_node_edgeに変更．

GitHub Copilot: ### [mk_semi_lattice.rb](file:///Users/bob/Desktop/Lectures/MultiScale/multi_scale_25f/knowledge_fixer/archives/s5_mk_lat_graph/mk_semi_lattice.rb)

`load_yaml_graph`関数名を`load_node_edge`に変更し、呼び出し箇所も修正します。

````ruby
# ...existing code...

def load_node_edge(path, nodes, edges, node_table)
  data = YAML.load_file(path)
  # ノード生成
  data['nodes'].each do |node|
    label = node['name']
    # ランダムな位置に配置
    x = rand(80..520)
    y = rand(80..520)
    add_node(nodes, node_table, label, x, y)
  end
  # エッジ生成
  data['edges'].each do |edge|
    from_id = edge['from']
    to_id = edge['to']
    from_node = data['nodes'].find { |n| n['id'] == from_id }
    to_node = data['nodes'].find { |n| n['id'] == to_id }
    if from_node && to_node
      add_edge(edges, node_table, from_node['name'], to_node['name'])
    end
  end
end

file = ARGV[0] || "dir_node_edge.yaml"
load_node_edge(file, nodes, edges, node_table)

# ...existing code...
````

Made changes.

daddygongon: nodeのnameで’/’で終わるdirectoryの時には，
class Folder
  # フォルダアイコンをRuby2Dの図形で描画するクラス
  def initialize(x, y, color: 'orange', z: 10)
    @x = x
    @y = y
    @color = color
    @z = z
  end

  def draw
    # フォルダ本体
    Rectangle.new(x: @x-28, y: @y-10, width: 56, height: 32, color: @color, z: @z)
    # フタ部分（左端を本体と揃える: x-28）
    Rectangle.new(x: @x-28, y: @y-20, width: 32, height: 16, color: @color, z: @z+1)
    # ※輪郭線は描画しない
  end
end

を描画するように変更．

GitHub Copilot: ### [mk_semi_lattice.rb](file:///Users/bob/Desktop/Lectures/MultiScale/multi_scale_25f/knowledge_fixer/archives/s5_mk_lat_graph/mk_semi_lattice.rb)

`name`が`/`で終わるノードはフォルダとして描画するように修正します。  
- `Folder`クラスを追加  
- `Node`に`is_folder`属性を追加し、`draw`で分岐  
- `add_node`で`is_folder`を判定して渡す

````ruby
# ...existing code...

class Folder
  # フォルダアイコンをRuby2Dの図形で描画するクラス
  def initialize(x, y, color: 'orange', z: 10)
    @x = x
    @y = y
    @color = color
    @z = z
  end

  def draw
    # フォルダ本体
    Rectangle.new(x: @x-28, y: @y-10, width: 56, height: 32, color: @color, z: @z)
    # フタ部分（左端を本体と揃える: x-28）
    Rectangle.new(x: @x-28, y: @y-20, width: 32, height: 16, color: @color, z: @z+1)
    # ※輪郭線は描画しない
  end
end

class Node
  attr_accessor :x, :y, :label, :fixed, :linked, :color, :dx, :dy, :is_folder

  def initialize(label, x, y, is_folder: false)
    @label = label
    @x = x
    @y = y
    @fixed = false
    @linked = false
    @color = NODE_COLOR
    @dx = 0.0
    @dy = 0.0
    @is_folder = is_folder
  end

  def update_position
    # ...existing code...
  end

  def draw(selected)
    c = if selected
      SELECT_COLOR
    elsif fixed
      FIXED_COLOR
    elsif linked
      LINKED_COLOR
    else
      NODE_COLOR
    end
    if is_folder
      Folder.new(x, y, color: c, z: 10).draw
      Text.new(label, x: x-24, y: y+25, size: 16, color: 'black', z: 11)
    else
      Circle.new(x: x, y: y, radius: 30, color: c, z: 10)
      Text.new(label, x: x-20, y: y-10, size: 18, color: 'black', z: 11)
    end
  end
end

# ...existing code...

def add_node(nodes, node_table, label, x, y)
  is_folder = label.end_with?('/')
  n = Node.new(label, x, y, is_folder: is_folder)
  nodes << n
  node_table[label] = n
  n
end

# ...existing code...
````

Made changes.

daddygongon: on :key_down do |event|
  @shift_pressed = true if event.key.include?('shift')
end

on :key_up do |event|
  @shift_pressed = false if event.key.include?('shift')
end

on :mouse_down do |event|
  mx, my = event.x, event.y
  shift_down = !!@shift_pressed
  #  p ["@shift_pressed:", @shift_pressed, ", shift_down:", shift_down] # ← デバッグ用
  nodes.each do |n|
    if Math.hypot(n.x - mx, n.y - my) < 30
      if shift_down
        n.fixed = false
        selected = nil
      else
        selected = n
        n.fixed = true if event.button == :left
        n.fixed = false if event.button == :middle
        n.linked = true if event.button == :right
      end
    end
  end
end
でshift_clickを使ってfixedを外すように修正．

GitHub Copilot: ### [mk_semi_lattice.rb](file:///Users/bob/Desktop/Lectures/MultiScale/multi_scale_25f/knowledge_fixer/archives/s5_mk_lat_graph/mk_semi_lattice.rb)

`shift`キー押下状態を管理し、`shift+click`でノードの`fixed`を外すように修正します。  
- `@shift_pressed`の管理を追加  
- `on :key_down`, `on :key_up`を追加  
- `on :mouse_down`で`shift_down`判定し、`shift+click`時は`fixed=false`&`selected=nil`

````ruby
# ...existing code...

@shift_pressed = false

on :key_down do |event|
  @shift_pressed = true if event.key.include?('shift')
end

on :key_up do |event|
  @shift_pressed = false if event.key.include?('shift')
end

on :mouse_down do |event|
  mx, my = event.x, event.y
  shift_down = !!@shift_pressed
  nodes.each do |n|
    if Math.hypot(n.x - mx, n.y - my) < 30
      if shift_down
        n.fixed = false
        selected = nil
      else
        selected = n
        n.fixed = true if event.button == :left
        n.fixed = false if event.button == :middle
        n.linked = true if event.button == :right
      end
    end
  end
end

# ...existing code...
````

Made changes.

daddygongon: folderのtextもcircleと同様にfolder iconの内部に描画するように．

GitHub Copilot: ### [mk_semi_lattice.rb](file:///Users/bob/Desktop/Lectures/MultiScale/multi_scale_25f/knowledge_fixer/archives/s5_mk_lat_graph/mk_semi_lattice.rb)

フォルダノードのラベルも、円ノードと同様にアイコンの内部（中央付近）に描画するように修正します。

````ruby
# ...existing code...
  def draw(selected)
    c = if selected
      SELECT_COLOR
    elsif fixed
      FIXED_COLOR
    elsif linked
      LINKED_COLOR
    else
      NODE_COLOR
    end
    if is_folder
      Folder.new(x, y, color: c, z: 10).draw
      # フォルダアイコンの中央付近にラベルを描画
      Text.new(label, x: x-20, y: y-2, size: 16, color: 'black', z: 11)
    else
      Circle.new(x: x, y: y, radius: 30, color: c, z: 10)
      Text.new(label, x: x-20, y: y-10, size: 18, color: 'black', z: 11)
    end
  end
# ...existing code...
````

Made changes.