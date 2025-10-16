require 'yaml'

def traverse(obj, parent = nil, nodes = Set.new, edges = [])
  case obj
  when Hash
    obj.each do |k, v|
      nodes << k.to_s
      edges << [parent, k.to_s] if parent
      traverse(v, k.to_s, nodes, edges)
    end
  when Array
    obj.each { |item| traverse(item, parent, nodes, edges) }
  when String
    nodes << obj
    edges << [parent, obj] if parent
  end
end

yaml_path = ARGV[0] || File.join(__dir__, '.', 'directories.yaml')
data = YAML.load_file(yaml_path)

require 'set'
nodes = Set.new
edges = []

traverse(data, nil, nodes, edges)

# 出力
nodes.each { |n| puts "node #{n}" }
edges.each { |p, c| puts "#{p}--#{c}" if p }
