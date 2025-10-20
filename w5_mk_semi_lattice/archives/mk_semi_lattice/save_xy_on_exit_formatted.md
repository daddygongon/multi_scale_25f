# head
date: 2025-10-20
author: bob

## User
quitするときに，nodeのx,y座標とfixed状態を保持したsemi_lattice.yamlを生成して終了するように修正．

## Copilot
````ruby
# ...existing code...

if __FILE__ == $0
  file = ARGV[0] || "dir_node_edge.yaml"
  app = MkSemiLattice.new(file)

  set width: 600, height: 600
  set title: "KnowledgeFixer Graph"
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

  on :close do
    # ノード情報を保存
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
    File.write("semi_lattice.yaml", YAML.dump(yaml_data))
  end

  show
end
````

Made changes.

## User
#terminalSelection とのエラーが出ます．

## Copilot
Read terminal selection

````ruby
# ...existing code...

if __FILE__ == $0
  file = ARGV[0] || "dir_node_edge.yaml"
  app = MkSemiLattice.new(file)

  set width: 600, height: 600
  set title: "KnowledgeFixer Graph"
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
    # ...existing code...
  end

  on :mouse_up do
    app.selected = nil
  end

  on :mouse_move do |event|
    # ...existing code...
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
    File.write("semi_lattice.yaml", YAML.dump(yaml_data))
  end

  show
end
````

Made changes.

## User
semi_lattice.yamlがカレントディレクトリにある場合は，そちらを読み込んで，nodeを作成し，x, y, fixed状態を反映させるように修正．

## Copilot
````ruby
# ...existing code...

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
    state_file = "semi_lattice.yaml"
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

# ...existing code...
````

Made changes.