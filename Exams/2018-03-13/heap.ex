#Impl av en maxheap

defmodule Heap do
  @type heap() :: :nil |  {:heap, integer(), heap(), heap()}
  @spec add(heap(), integer()) :: heap()


  def add(:nil, v) do
    {:heap, v, :nil, :nil}
  end
  #annars lägg direkt under children. Swappa vänster och höger för att behålla balanserad struktur
  def add({:heap, k, l, r}, v) when k > v do
    {:heap, k, add(r, v), l}
  end
  #skapa en ny nod (flytta upp noden vi har) och attach children
  def add({:heap, k, l, r}, v) do
    {:heap, v, add(r, k), l}
  end

  #for a general heap, with function cmp that compares two elements(not bounded to integers)
  @type cmp() :: (any(), any()) -> bool())
  @spec add(heap(), any(), cmp()) :: heap()


  def add({:heap, a, l, r}, b, cmp) do
    bool = cmp.(a, b)
    case bool do
      true ->
        {:heap, a, add(r, b), l}
      false ->
        {:heap, b, add(r, a), r}
    end
  end

  @type cheap() :: {:cheap, heap(), cmp()}
  @spec new(cmp()) :: cheap()
  @spec add(cheap(), any()) :: cheap()

  def new(cmp) do
    {:cheap, :nil, cmp}
  end
  #add/2 takes a cheap() structure and calls add/3
  def add({:cheap, heap, cmp}, a) do
    new_heap =  add(heap, a, cpm)
    {:cheap, new_heap, cmp}
  end

  @spec pop(heap()) :: :fail | {:ok, integer(), heap()}

  def pop(:nil) do :fail end
  def pop({:heap, val, l, :nil}) do
    {:ok, val, l}
  end
  def pop({:heap, val, :nil, r}) do
    {:ok, val, r}
  end

  def pop({:heap, val, l, r}) do
    {:heap, l_val, _, _} = l
    {:heap, r_val, _, _} = r

    if l_val < r_val do
      {:ok, _, rest} = pop(r)
      {:ok, val, {:heap, r_val, l, rest}}
    else
      {:ok, _, rest} = pop(l)
      {:ok, val, {:heap, l_val, rest, r}}
    end
  end

  @spec swap(heap(), integer()) :: {:ok, integer(), heap()}
  #en kombination av en add och sedan retur av


  #lägg till int i correct pos i trädet, returnera maxtalet  trädet
  def swap({:heap, val, l, r}, int) when int < val do
    {:ok, int, left} = swap(l, int)
    {:ok, int, right} = swap(r, int)
    {:ok, val, {:heap, int, left, right}}
  end

  def swap(heap, v) do


  def test() do
    heap = {:heap, 8,
            {:heap, 2,
              :nil,
              {:heap, 1,
                :nil,
                :nil}},
            {:heap, 5,
              {:heap, 3,
                :nil,
                :nil},
              :nil}}

    swap(heap, 4)
  end

end

defmodule Middle do
  @spec new(cmp()) :: cheap()

def start() do
  spawn(fn() -> mid())
end

def mid() do
  receive do
    {:add, int} ->
      left = Heap.new(x, y) <
    {:get, pid()} ->
      if :nil do
        :fail
      else
        get_middle(heap)
        {:ok, int}
end


end
