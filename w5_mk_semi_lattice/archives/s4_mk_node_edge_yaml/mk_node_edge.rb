require 'yaml'

def node_type(name)
  name.end_with?('/') ? 'dir' : 'file'
end

def traverse(hash, parent_id = nil, parent_path = '', nodes = [], edges = [], id_counter = [1], path_to_id = {}, id_to_name = {})
  hash.each do |key, value|
    name = key
    type = value.is_a?(Hash) || name.end_with?('/') ? 'dir' : 'file'
    current_path = parent_path.empty? ? name : File.join(parent_path, name)
    id = id_counter[0]
    id_counter[0] += 1
    nodes << { id: id, name: name, type: type }
    path_to_id[current_path] = id
    id_to_name[id] = name
    if parent_id
      comment = "# from: #{id_to_name[parent_id]}, to: #{name}"
      edges << { from: parent_id, to: id, comment: comment }
    end
    if value.is_a?(Hash)
      traverse(value, id, current_path, nodes, edges, id_counter, path_to_id, id_to_name)
    end
  end
  [nodes, edges]
end

input_path = File.join(__dir__, 'dir.yaml')
output_path = File.join(__dir__, 'dir_node_edge.yaml')

dir_hash = YAML.load_file(input_path)
root_key = dir_hash.keys.first
root_value = dir_hash[root_key]

nodes, edges = [], []
id_counter = [1]
path_to_id = {}
id_to_name = {}

# ルートノード追加
nodes << { id: id_counter[0], name: "#{root_key}/", type: 'dir' }
root_id = id_counter[0]
path_to_id[root_key] = root_id
id_to_name[root_id] = "#{root_key}/"
id_counter[0] += 1

traverse(root_value, root_id, root_key, nodes, edges, id_counter, path_to_id, id_to_name)

output_hash = {
  'nodes' => nodes,
  'edges' => edges
}

File.open(output_path, 'w') { |f| f.write(output_hash.to_yaml) }
