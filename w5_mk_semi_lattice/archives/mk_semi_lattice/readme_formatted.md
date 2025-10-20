# head
date: 2025-10-20
author: bob

## User
全体をクラス化してMkSemiLatticeとくしてださい．


[mk_semi_lattice.rb](./codes/nowledge_fixer.rb)

全体を`MkSemiLattice`クラスにまとめ、初期化・イベント・描画・データロードなどをメソッド化します。グローバル変数や関数はインスタンス変数・メソッドに置き換えます。

````ruby
require 'ruby2d'
require 'yaml'

NODE_COLOR = 'orange'
SELECT_COLOR = 'red'
FIXED_COLOR = 'green'
LINKED_COLOR = 'blue'
EDGE_COLOR = 'black'

class Folder
  # ...existing code...
end

class Node
  # ...existing code...
end

class Edge
  # ...existing code...
end

class MkSemiLattice
  def initialize(file = "dir_node_edge.yaml")
    set width: 600, height: 600
    set title: "KnowledgeFixer Graph"
    set background: 'white'

    @nodes = []
    @edges = []
    @node_table = {}
    @selected = nil
    @shift_pressed = false

    load_yaml_data(file)

    setup_events
    start_update_loop
    show
  end

  def add_node(id, x, y, label = nil, type = nil)
    display_label = label
    n = Node.new(display_label, x, y, type)
    @nodes << n
    @node_table[id] = n
    n
  end

  def add_edge(from_id, to_id)
    from = @node_table[from_id]
    to = @node_table[to_id]
    @edges << Edge.new(from, to) if from && to
  end

  def load_yaml_data(path)
    data = YAML.load_file(path, symbolize_names: true)
    data[:nodes].each do |node_data|
      id = node_data[:id]
      name = node_data[:name]
      type = node_data[:type]
      x = rand(80..520)
      y = rand(80..520)
      label = name
      add_node(id, x, y, label, type)
    end
    data[:edges].each do |edge_data|
      from_id = edge_data[:from]
      to_id = edge_data[:to]
      add_edge(from_id, to_id)
    end
  end

  def setup_events
    on :key_down do |event|
      @shift_pressed = true if event.key.include?('shift')
    end

    on :key_up do |event|
      @shift_pressed = false if event.key.include?('shift')
    end

    on :mouse_down do |event|
      mx, my = event.x, event.y
      shift_down = !!@shift_pressed
      @nodes.each do |n|
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
  end

  def start_update_loop
    update do
      clear
      @edges.each(&:relax)
      @nodes.each { |n| n.relax(@nodes) }
      @nodes.each(&:update)
      @edges.reverse.each(&:draw)
      @nodes.reverse.each { |n| n.draw(@selected == n) }
    end
  end
end

if __FILE__ == $0
  file = ARGV[0] || "dir_node_edge.yaml"
  MkSemiLattice.new(file)
end
````

Made changes.

## User
#terminalSelection です．Ruby Classのインスタンス変数の初期化に直しなさい．
```bash
./mk_semi_lattice.rb:136:in `initialize': undefined method `set' for #<MkSemiLattice:0x0000000137932ac8> (NoMethodError)
Did you mean?  send
        from ./mk_semi_lattice.rb:238:in `new'
        from ./mk_semi_lattice.rb:238:in `<main>'
````
## Copilot
Read terminal selection


[mk_semi_lattice.rb](./codes/nowledge_fixer.rb)

`set`, `show`, `on`, `update`, `clear` などはトップレベルで呼ぶ必要があるため、`MkSemiLattice`のインスタンス変数の初期化（`initialize`）ではインスタンス変数のみセットし、イベントや描画ループ、ウィンドウ設定はクラス外で行う形に修正します。

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
    load_yaml_data(file)
  end

  # ...existing code...
end

if __FILE__ == $0
  file = ARGV[0] || "dir_node_edge.yaml"
  set width: 600, height: 600
  set title: "KnowledgeFixer Graph"
  set background: 'white'

  app = MkSemiLattice.new(file)

  on :key_down do |event|
    app.shift_pressed = true if event.key.include?('shift')
  end

  on :key_up do |event|
    app.shift_pressed = false if event.key.include?('shift')
  end

  on :mouse_down do |event|
    mx, my = event.x, event.y
    shift_down = !!app.shift_pressed
    app.nodes.each do |n|
      if Math.hypot(n.x - mx, n.y - my) < 30
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

  show
end
````

Made changes.

## User
Rakefileのmk_graph動作を切り出して，mk_semi_latticeというrubyの実行ファイルにしなさい．


[Rakefile](./codes/nowledge_fixer.rb)

`mk_graph`タスクの処理を削除し、Rakefileはデフォルトタスクのみ残します。

````ruby
# -*- coding: utf-8 -*-
require "colorize"
require 'command_line/global'

task :default do
  system "rake -T"
end

# ...existing code...
````

---


[mk_semi_lattice](./codes/nowledge_fixer.rb)

`mk_graph`タスクの処理を新しい実行ファイル`mk_semi_lattice`に移します。
このファイルは`/Users/bob/bin/mk_cli_copilot/mk_semi_lattice/mk_semi_lattice`として保存してください（拡張子なし、実行権限を付与）。

````ruby
#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

dir = ARGV[0] || '.'
layer = ARGV[1] || '2'

system "ruby ./mk_dir_yaml.rb -L #{layer.to_i} #{dir}"
system "ruby ./mk_node_edge.rb"
exec  "ruby ./mk_semi_lattice.rb"
````

Made changes.