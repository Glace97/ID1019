#ways of repsenting a graph

#list of edges [{:from node, :to node, cost(int)}, ....]
#list of nodes, tuples of neighbors [{:a, {:b,2}, {:d,5}}, {:b, {.....}}, ....]
#matrix of edges-> {{:nil, 2 ,nil, 5, nil,nil,nil}, {}
#g = {:g, []}
# e = {:e, {[g,2]}}  access to all nodes, list of edges <-- best representation

defmodule Graph do
  def sample() do
    new([a: [b: 2, d: 5], b: [c: 2])
  end

  def new(nodes) do
    Map.new(nodes)
  end

  def next(from, map) do
    Map.get(map, from, [])
  end
end
