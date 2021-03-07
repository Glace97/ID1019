defmodule Compact do
  @type tree() :: :nil | {:node, tree(), tree()} | {:leaf, any()}

  #traversal down tree
  def compact(:nil) do :nil end
  def compact({:leaf, value}) do
    {:leaf, value}
  end
  def compact({:node, l, r}) do
    cl = compact(l)
    cr = compact(r)
    combine(cl, cr)
  end

  #combine
  #case: a single leaf
  def combine(:nil, {:leaf, value}) do
    {:leaf, value}
  end
  def combine({:leaf, value}, :nil) do
    {:leaf, value}
  end

  #case:two leaves with same value
  def combine({:leaf, value}, {:leaf, value}) do
    {:leaf, value}
  end

  #case two subtrees
  def combine(l, r) do
    {:node, l, r}
  end
  
end
