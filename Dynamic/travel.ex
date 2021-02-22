defmodule Travel do

  #returns shortest path given from to, given a graph
  #returns {:inf, nil} if no such path exists
  def shortest(from, from, _) do {0, []} end

  def shortest(from, to , graph) do
    next = Graph.next(from, graph)  #all nodes we can travel to
    distances = distances(next, to, graph) #calculates cost for each note
    select(distances) # select cheapest from list "distances"
  end

  def distances(next, to, graph) do
    #which nodes within reach? given a starting node
    Enum.map(next, fn({n,d}) ->
      case shortest(n, to, graph) do
        {:inf, nil} -> {:inf, nil}
        {k, path} -> {d+k, [n|path]}
      end
    end)
  end

  def select(distances) do
    List.doldl(distances,
    {:inf, nil},
    fn({d,_}  = s, {ad,_}=acc) ->
      if d< ad do
        s
      else
        acc
      end
    end)
  end
end
