require 'ruby2d'
require 'yaml'

set width: 1200, height: 700
set title: "Hello Circles"
set background: 'white'

class Icon
  def initialize(x, y, text, color)
    # 円の描画（半径を小さく）
    Circle.new(
      x: x, y: y,
      radius: 32,
      sectors: 32,
      color: color,
      z: 10
    )
    Circle.new(
      x: x, y: y,
      radius: 30,
      sectors: 32,
      color: 'white',
      z: 11
    )
    # テキストサイズ取得
    tmp_text = Text.new(
      text,
      x: 0, y: 0,
      font: "RobotoMonoNerdFontMono-Regular.ttf",
      size: 14,
      color: 'blue',
      rotate: 0,
      z: 0,
    )
    text_width = tmp_text.width
    text_height = tmp_text.height
    tmp_text.remove

    # テキストの中心を円の中心に合わせる
    text_x = x - text_width / 2
    text_y = y - text_height / 2

    Text.new(
      text,
      x: text_x, y: text_y,
      font: "RobotoMonoNerdFontMono-Regular.ttf",
      size: 14,
      color: 'black',
      rotate: 0,
      z: 12
    )
  end
end

def mk_circles(yaml_path)
  data = YAML.load_file(yaml_path)
  colors = %w[navy blue aqua teal olive green lime yellow orange red brown fuchsia purple maroon white silver gray black]
  @icon_index = 0

  center_x, center_y = 600, 350
  base_radius = 60
  step_radius = 60

  # 階層ごとのノード数をカウント
  level_counts = Hash.new(0)
  count_per_level = lambda do |node, depth = 0|
    case node
    when Hash
      node.each { |k, v| level_counts[depth] += 1; count_per_level.call(v, depth + 1) }
    when Array
      node.each { |item| count_per_level.call(item, depth) }
    else
      level_counts[depth] += 1 unless node.to_s.empty?
    end
  end
  count_per_level.call(data)

  traverse = lambda do |node, parent_center = [center_x, center_y], depth = 0, sibling_idx = 0|
    # 子要素を配列化
    children = []
    case node
    when Hash
      node.each { |k, v| children << [k, v] }
    when Array
      node.each { |item| children << item }
    else
      children << node
    end

    n = children.size
    children.each_with_index do |item, idx|
      # 階層ごとの総ノード数で角度を決定
      total = level_counts[depth + 1] > 0 ? level_counts[depth + 1] : n
      angle = total > 1 ? (2 * Math::PI * sibling_idx / total) : 0
      radius = base_radius + depth * step_radius
      x = parent_center[0] + radius * Math.cos(angle)
      y = parent_center[1] + radius * Math.sin(angle)
      color = colors[@icon_index % colors.size]

      if item.is_a?(Array) && item.size == 2 && item[0].is_a?(String)
        text = item[0].to_s
        Icon.new(x, y, text, color)
        Line.new(
          x1: parent_center[0], y1: parent_center[1],
          x2: x, y2: y,
          width: 2,
          color: 'gray',
          z: 5
        )
        @icon_index += 1
        traverse.call(item[1], [x, y], depth + 1, sibling_idx)
        sibling_idx += 1
      elsif item.is_a?(Hash) || item.is_a?(Array)
        traverse.call(item, [x, y], depth + 1, sibling_idx)
        sibling_idx += 1
      else
        text = item.to_s
        unless text.empty?
          Icon.new(x, y, text, color)
          Line.new(
            x1: parent_center[0], y1: parent_center[1],
            x2: x, y2: y,
            width: 2,
            color: 'gray',
            z: 5
          )
          @icon_index += 1
          sibling_idx += 1
        end
      end
    end
  end

  traverse.call(data)
end

# Icon.new(320, 250, 'Hello', 'red')
mk_circles('tmp.yaml')
show
