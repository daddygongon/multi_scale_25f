require 'yaml'

def traverse(node, parent_id, nodes, edges, id_counter, id_name_map)
  if node.is_a?(Hash)
    node.each do |name, value|
      node_id = id_counter[:val]
      id_counter[:val] += 1

      type = value.is_a?(Hash) || value.is_a?(Array) ? 'dir' : 'file'
      nodes << {
        'id' => node_id,
        'name' => name,
        'type' => type
      }
      id_name_map[node_id] = name
      if parent_id
        edges << {
          'from' => parent_id,
          'to' => node_id
        }
      end

      if value.is_a?(Hash) || value.is_a?(Array)
        traverse(value, node_id, nodes, edges, id_counter, id_name_map)
      end
    end
  elsif node.is_a?(Array)
    node.each do |item|
      traverse(item, parent_id, nodes, edges, id_counter, id_name_map)
    end
  end
end

input_path = 'dir.yaml'
output_path = 'dir_node_edge.yaml'

dir_tree = YAML.load_file(input_path)
nodes = []
edges = []
id_counter = { val: 1 }
id_name_map = {}

traverse(dir_tree, nil, nodes, edges, id_counter, id_name_map)

output = { 'nodes' => nodes, 'edges' => edges }

yaml_str = output.to_yaml

# コメント追加
yaml_lines = yaml_str.lines
new_yaml_lines = []
edges_section = false
edges_idx = 0

edges_count = edges.size

yaml_lines.each do |line|
  new_yaml_lines << line
  if line.strip == 'edges:'
    edges_section = true
    next
  end
  if edges_section && line.strip.start_with?('- from:')
    edge = edges[edges_idx]
    from_name = id_name_map[edge['from']]
    to_name = id_name_map[edge['to']]
    comment = "# from: #{from_name}, to: #{to_name}"
    new_yaml_lines << "  #{comment}\n"
    edges_idx += 1
    edges_section = false if edges_idx >= edges_count
  end
end

File.write(output_path, new_yaml_lines.join)
