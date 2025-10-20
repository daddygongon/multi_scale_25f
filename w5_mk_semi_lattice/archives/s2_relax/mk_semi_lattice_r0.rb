require 'ruby2d'

set width: 600, height: 600
set title: "KnowledgeFixer Graph"
set background: 'white'

NODE_COLOR = 'orange'
SELECT_COLOR = 'red'
FIXED_COLOR = 'green'
LINKED_COLOR = 'blue'
EDGE_COLOR = 'black'

class Node
  attr_accessor :x, :y, :dx, :dy, :fixed, :linked, :color

  def initialize(label, size = 10, link_to = "")
    @label = label
    @size = size
    @link_to = link_to
    @x = rand(600)
    @y = rand(600)
    @dx = 0.0
    @dy = 0.0
    @fixed = false
    @linked = false
    @color = NODE_COLOR
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
    Circle.new(x: x, y: y, radius: 30, color: c, z: 10)
    Text.new(@label, x: x-20, y: y-10, size: 18, color: 'black', z: 11)
  end

  def relax(nodes)
    ddx = 0.0
    ddy = 0.0
    nodes.each do |n|
      next if n == self
      vx = @x - n.x
      vy = @y - n.y
      lensq = vx * vx + vy * vy
      if lensq == 0
        ddx += rand
        ddy += rand
      elsif lensq < 100 * 100
        ddx += vx / lensq
        ddy += vy / lensq
      end
    end
    dlen = Math.sqrt(ddx * ddx + ddy * ddy) / 2.0
    if dlen > 0
      @dx += ddx / dlen
      @dy += ddy / dlen
    end
  end

  def update(width = 600, height = 600)
    unless @fixed
      @x += [[@dx, -5].max, 5].min
      @y += [[@dy, -5].max, 5].min
      @x = [[@x, 0].max, width].min
      @y = [[@y, 0].max, height].min
    end
    @dx /= 2.0
    @dy /= 2.0
  end
end

class Edge
  attr_reader :from, :to
  def initialize(from, to)
    @from = from
    @to = to
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
def add_node(nodes, node_table, label, x, y)
  n = Node.new(label, x, y)
  nodes << n
  node_table[label] = n
  n
end

# 例: エッジ追加
def add_edge(edges, node_table, from_label, to_label)
  from = node_table[from_label]
  to = node_table[to_label]
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
def load_pattern_language(path, nodes, edges, node_table)
  File.readlines(path, chomp: true).each do |line|
    tokens = line.strip.split
    next if tokens.empty?
    if tokens[0] == "node"
      label = tokens[1]
      # ランダムな位置に配置
      x = rand(80..520)
      y = rand(80..520)
      add_node(nodes, node_table, label, x, y)
    elsif line.include?("--")
      from_label, to_label = line.split("--").map(&:strip)
      add_edge(edges, node_table, from_label, to_label)
    end
  end
end

# 既存のサンプルデータ追加部分を削除し、以下を追加
file = ARGV[0] || "data/PatternLanguage.txt"
load_pattern_language(file, nodes, edges, node_table)

selected = nil

on :mouse_down do |event|
  mx, my = event.x, event.y
  nodes.each do |n|
    if Math.hypot(n.x - mx, n.y - my) < 30
      selected = n
      n.fixed = true if event.button == :left
      n.fixed = false if event.button == :middle
      n.linked = true if event.button == :right
    end
  end
end

on :mouse_up do
  selected = nil
end

on :mouse_move do |event|
  if selected
    selected.x = event.x
    selected.y = event.y
  end
end

update do
  clear
  edges.each(&:draw)
  nodes.each { |n| n.draw(selected == n) }
end

show
