require 'ruby2d'
require 'yaml'

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
  attr_accessor :x, :y, :label, :fixed, :linked, :color, :dx, :dy, :type, :file_path

  def initialize(label, x, y, type = nil, file_path = nil)
    @label = label
    @x = x
    @y = y
    @fixed = false
    @linked = false
    @color = NODE_COLOR
    @dx = 0.0
    @dy = 0.0
    @type = type
    @file_path = file_path
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

class MkSemiLattice
  attr_reader :nodes, :edges, :node_table
  attr_accessor :selected, :shift_pressed

  def initialize(file = "dir_node_edge.yaml")
    @nodes = []
    @edges = []
    @node_table = {}
    @selected = nil
    @shift_pressed = false
    load_yaml_data_with_state(file)
  end

  def add_node(id, x, y, label = nil, type = nil, file_path = nil, fixed = false)
    display_label = label
    n = Node.new(display_label, x, y, type, file_path)
    n.fixed = fixed
    @nodes << n
    @node_table[id] = n
    n
  end

  def add_edge(from_id, to_id)
    from = @node_table[from_id]
    to = @node_table[to_id]
    @edges << Edge.new(from, to) if from && to
  end

  def load_yaml_data_with_state(path)
    state_file = File.join(File.dirname(__FILE__), '.semi_lattice', "semi_lattice.yaml")
    if File.exist?(state_file)
      data = YAML.load_file(state_file)
      nodes_data = data[:nodes] || data['nodes']
      edges_data = data[:edges] || data['edges']
      nodes_data.each do |node_data|
        id = node_data[:id] || node_data['id']
        name = node_data[:name] || node_data['name']
        type = node_data[:type] || node_data['type']
        file_path = node_data[:file_path] || node_data['file_path']
        x = node_data[:x] || node_data['x'] || rand(80..520)
        y = node_data[:y] || node_data['y'] || rand(80..520)
        fixed = node_data[:fixed] || node_data['fixed'] || false
        label = name
        add_node(id, x, y, label, type, file_path, fixed)
      end
      edges_data.each do |edge_data|
        from_id = edge_data[:from] || edge_data['from']
        to_id = edge_data[:to] || edge_data['to']
        add_edge(from_id, to_id)
      end
    else
      data = YAML.load_file(path, symbolize_names: true)
      data[:nodes].each do |node_data|
        id = node_data[:id]
        name = node_data[:name]
        type = node_data[:type]
        file_path = node_data[:file_path]
        x = rand(80..520)
        y = rand(80..520)
        label = name
        add_node(id, x, y, label, type, file_path, false)
      end
      data[:edges].each do |edge_data|
        from_id = edge_data[:from]
        to_id = edge_data[:to]
        add_edge(from_id, to_id)
      end
    end
  end
end

# --- ここからWindowクラスを削除し、main loopに戻ります ---

if __FILE__ == $0
  file = ARGV[0] || "dir_node_edge.yaml"
  app = MkSemiLattice.new(file)

  # top nodeのname（label）をタイトルに使う
  top_node_label = app.nodes.first&.label || "KnowledgeFixer Graph"
  set width: 600, height: 600
  set title: top_node_label
  set background: 'white'

  last_click_time = nil
  last_click_node = nil

  on :key_down do |event|
    app.shift_pressed = true if event.key.include?('shift')
  end

  on :key_up do |event|
    app.shift_pressed = false if event.key.include?('shift')
  end

  on :mouse_down do |event|
    mx, my = event.x, event.y
    shift_down = !!app.shift_pressed
    clicked_node = nil
    app.nodes.each do |n|
      if Math.hypot(n.x - mx, n.y - my) < 30
        clicked_node = n
        if shift_down
          n.fixed = false
          app.selected = nil
        else
          app.selected = n
          n.fixed = true if event.button == :left
          n.fixed = false if event.button == :middle
          n.linked = true if event.button == :right
        end
      end
    end

    # ダブルクリック判定とファイルオープン
    now = Time.now
    if clicked_node
      if last_click_node == clicked_node && last_click_time && (now - last_click_time < 0.4)
        system("open #{clicked_node.file_path}") if clicked_node.file_path
      end
      last_click_time = now
      last_click_node = clicked_node
    end
  end

  on :mouse_up do
    app.selected = nil
  end

  on :mouse_move do |event|
    if app.selected
      app.selected.x = event.x
      app.selected.y = event.y
    end
  end

  update do
    clear
    app.edges.each(&:relax)
    app.nodes.each { |n| n.relax(app.nodes) }
    app.nodes.each(&:update)
    app.edges.reverse.each(&:draw)
    app.nodes.reverse.each { |n| n.draw(app.selected == n) }
  end

  # Ruby2Dには:closeイベントはありません。at_exitで保存処理を行います。
  at_exit do
    nodes_data = app.nodes.map do |n|
      {
        id: app.node_table.key(n),
        name: n.label,
        type: n.type,
        file_path: n.file_path,
        x: n.x,
        y: n.y,
        fixed: n.fixed
      }
    end
    edges_data = app.edges.map do |e|
      {
        from: app.node_table.key(e.from),
        to: app.node_table.key(e.to)
      }
    end
    yaml_data = { nodes: nodes_data, edges: edges_data }
    File.write(File.join(File.dirname(__FILE__), '.semi_lattice', "semi_lattice.yaml"), 
      YAML.dump(yaml_data))
  end

  show
end
