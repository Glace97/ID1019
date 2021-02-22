#use maps instead for memory, O(logn)
defmodule Better do

  def new() do %{} end

  def store(k, v, mem) do
    Map.put(mem, k, v)
  end

  def lookup(k, mem) do
    Map.get(mem, k)
  end

end
