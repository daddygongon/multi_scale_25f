require 'ruby2d'
require 'yaml'

set width: 600, height: 600
set title: "KnowledgeFixer Graph"
set background: 'white'

NODE_COLOR = 'orange'
SELECT_COLOR = 'red'
FIXED_COLOR = 'green'
LINKED_COLOR = 'blue'
EDGE_COLOR = 'black'

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
  attr_accessor :x, :y, :label, :fixed, :linked, :color, :dx, :dy, :type

  def initialize(label, x, y, type = nil)
    @label = label
    @x = x
    @y = y
    @fixed = false
    @linked = false
    @color = NODE_COLOR
    @dx = 0.0
    @dy = 0.0
    @type = type
  end

  def update
    unless fixed
      @x += [@dx, -5, 5].sort[1]
      @y += [@dy, -5, 5].sort[1]
      
      @x = [[@x, 0].max, 600].min
      @y = [[@y, 0].max, 600].min
    end
    @dx /= 2.0
    @dy /= 2.0
  end

  def relax(nodes)
    ddx = 0
    ddy = 0

    nodes.each do |n|
      next if n == self
      
      vx = x - n.x
      vy = y - n.y
      lensq = vx * vx + vy * vy
      
      if lensq == 0
        ddx += rand(-1.0..1.0)
        ddy += rand(-1.0..1.0)
      elsif lensq < 100 * 100
        ddx += vx / lensq
        ddy += vy / lensq
      end
    end
    
    dlen = Math.sqrt(ddx * ddx + ddy * ddy) / 2
    if dlen > 0
      @dx += ddx / dlen
      @dy += ddy / dlen
    end
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
    if @type == 'dir'
      Folder.new(x, y, color: c, z: 10).draw
      Text.new(label, x: x-20, y: y-10, size: 18, color: 'black', z: 11)
    else
      Circle.new(x: x, y: y, radius: 30, color: c, z: 10)
      Text.new(label, x: x-20, y: y-10, size: 18, color: 'black', z: 11)
    end
  end
end

class Edge
  attr_reader :from, :to
  def initialize(from, to)
    @from = from
    @to = to
    @len = 75.0
  end

  def relax
    vx = to.x - from.x
    vy = to.y - from.y
    d = Math.hypot(vx, vy)
    if d > 0
      f = (@len - d) / (d * 5)
      dx = f * vx
      dy = f * vy
      to.dx += dx
      to.dy += dy
      from.dx -= dx
      from.dy -= dy
    end
  end

  def update
    # 何も処理しないが、将来拡張用
  end

  def draw
    Line.new(x1: from.x, y1: from.y, x2: to.x, y2: to.y, width: 2, color: EDGE_COLOR, z: 5)
  end
end

# ノードとエッジの初期化例
nodes = []
edges = []
node_table = {}

# 例: ノード追加
def add_node(nodes, node_table, id, x, y, label = nil, type = nil)
  display_label = label # labelはnameのみを渡す
  n = Node.new(display_label, x, y, type)
  nodes << n
  node_table[id] = n
  n
end

# 例: エッジ追加
def add_edge(edges, node_table, from_id, to_id)
  from = node_table[from_id]
  to = node_table[to_id]
  edges << Edge.new(from, to) if from && to
end

=begin # サンプルデータ
add_node(nodes, node_table, "A", 100, 100)
add_node(nodes, node_table, "B", 300, 200)
add_node(nodes, node_table, "C", 200, 400)
add_edge(edges, node_table, "A", "B")
add_edge(edges, node_table, "B", "C")
add_edge(edges, node_table, "C", "A")
=end
# サンプルデータ
def load_yaml_data(path, nodes, edges, node_table)
  data = YAML.load_file(path, symbolize_names: true)
  
  # ノードを作成
  data[:nodes].each do |node_data|
    id = node_data[:id]
    name = node_data[:name]
    type = node_data[:type]
    
    # ランダムな位置に配置
    x = rand(80..520)
    y = rand(80..520)
    
    # ノードのラベルはnameのみ
    label = name
    add_node(nodes, node_table, id, x, y, label, type)
  end
  
  # エッジを作成
  data[:edges].each do |edge_data|
    from_id = edge_data[:from]
    to_id = edge_data[:to]
    add_edge(edges, node_table, from_id, to_id)
  end
end

# 既存のサンプルデータ追加部分を削除し、以下を追加
file = ARGV[0] || "dir_node_edge.yaml"
load_yaml_data(file, nodes, edges, node_table)

@selected = nil
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
        @selected = nil
      else
        @selected = n
        n.fixed = true if event.button == :left
        n.fixed = false if event.button == :middle
        n.linked = true if event.button == :right
      end
    end
  end
end

on :mouse_up do
  @selected = nil
end

on :mouse_move do |event|
  if @selected
    @selected.x = event.x
    @selected.y = event.y
  end
end

update do
  clear
  edges.each(&:relax)
  nodes.each { |n| n.relax(nodes) }
  nodes.each(&:update)
  edges.reverse.each(&:draw)
  nodes.reverse.each { |n| n.draw(@selected == n) }
end

show
