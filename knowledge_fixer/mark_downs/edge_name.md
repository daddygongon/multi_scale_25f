daddygongon: Edgeの中央部にtext='hoge'と表示するように修正して

GitHub Copilot: ````ruby
# ...existing code...
class Edge
  attr_reader :from, :to
  attr_accessor :len

  def initialize(from, to, len = 75)
    @from = from
    @to = to
    @len = len
  end

  def relax
    vx = to.x - from.x
    vy = to.y - from.y
    d = Math.sqrt(vx * vx + vy * vy)
    
    if d > 0
      f = (len - d) / (d * 5)
      dx = f * vx
      dy = f * vy
      to.dx += dx
      to.dy += dy
      from.dx -= dx
      from.dy -= dy
    end
  end

  def draw
    Line.new(x1: from.x, y1: from.y, x2: to.x, y2: to.y, width: 2, color: EDGE_COLOR, z: 5)
    # Edgeの中央にテキスト"hoge"を表示
    mx = (from.x + to.x) / 2.0
    my = (from.y + to.y) / 2.0
    Text.new('hoge', x: mx - 15, y: my - 10, size: 16, color: 'gray', z: 6)
  end
end
# ...existing code...
````

daddygongon: rb版の読み込むfileをcliで指定できるように修正．

GitHub Copilot: ````ruby
# ...existing code...

# コマンドライン引数でファイル指定、なければ標準入力から受け取る
if ARGV[0]
  file = ARGV[0]
else
  puts "ファイルパスを入力してください:"
  file = STDIN.gets.chomp
end
load_pattern_language(file, nodes, edges, node_table)

# ...existing code...
````

daddygongon: 読み込んだtxtでedgeにつけるtextを
階段的な屋外空間--生き生きとした中庭 hoge1
のhoge1のように読み込んde,

GitHub Copilot: ````ruby
# ...existing code...

class Edge
  attr_reader :from, :to
  attr_accessor :len, :label

  def initialize(from, to, len = 75, label = nil)
    @from = from
    @to = to
    @len = len
    @label = label
  end

  def relax
    vx = to.x - from.x
    vy = to.y - from.y
    d = Math.sqrt(vx * vx + vy * vy)
    
    if d > 0
      f = (len - d) / (d * 5)
      dx = f * vx
      dy = f * vy
      to.dx += dx
      to.dy += dy
      from.dx -= dx
      from.dy -= dy
    end
  end

  def draw
    Line.new(x1: from.x, y1: from.y, x2: to.x, y2: to.y, width: 2, color: EDGE_COLOR, z: 5)
    mx = (from.x + to.x) / 2.0
    my = (from.y + to.y) / 2.0
    if label && !label.empty?
      Text.new(label, x: mx - 15, y: my - 10, size: 16, color: 'gray', z: 6)
    end
  end
end

# ...existing code...

def add_edge(edges, node_table, from_label, to_label, edge_label = nil)
  from = node_table[from_label]
  to = node_table[to_label]
  edges << Edge.new(from, to, 75, edge_label) if from && to
end

def load_pattern_language(path, nodes, edges, node_table)
  File.readlines(path, chomp: true).each do |line|
    tokens = line.strip.split
    next if tokens.empty?
    if tokens[0] == "node"
      label = tokens[1]
      x = rand(80..520)
      y = rand(80..520)
      add_node(nodes, node_table, label, x, y)
    elsif line.include?("--")
      # エッジラベル対応
      edge_part, *rest = line.split
      from_label, to_label = edge_part.split("--").map(&:strip)
      edge_label = rest.join(" ")
      add_edge(edges, node_table, from_label, to_label, edge_label)
    end
  end
end

# ...existing code...
````