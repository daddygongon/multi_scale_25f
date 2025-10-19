# head
date: 2025-10-18
author: bob

## User
rbのEdge classにrelax, updateを追加して，mainからそれらを呼ぶように修正してください．


[mk_semi_lattice.rb](./codes/nowledge_fixer.rb)

Edgeクラスに`relax`と`update`メソッドを追加し、mainループ（`update do`ブロック）から各エッジの`relax`と`update`を呼び出すように修正します。
ノードの座標を調整するため、Edgeの`relax`でノードの`dx`, `dy`を更新し、Nodeに`dx`, `dy`プロパティと`update_position`メソッドを追加します。

````ruby
# ...existing code...
class Node
  attr_accessor :x, :y, :label, :fixed, :linked, :color, :dx, :dy

  def initialize(label, x, y)
    @label = label
    @x = x
    @y = y
    @fixed = false
    @linked = false
    @color = NODE_COLOR
    @dx = 0.0
    @dy = 0.0
  end

  def update_position
    unless fixed
      @x += [[dx, -5].max, 5].min
      @y += [[dy, -5].max, 5].min
      @x = [[@x, 0].max, 600].min
      @y = [[@y, 0].max, 600].min
    end
    @dx /= 2.0
    @dy /= 2.0
  end

  # ...existing code...
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

  # ...existing code...
end
# ...existing code...

update do
  clear
  edges.each(&:relax)
  nodes.each(&:update_position)
  edges.each(&:update)
  edges.each(&:draw)
  nodes.each { |n| n.draw(selected == n) }
end

# ...existing code...
````

Made changes.