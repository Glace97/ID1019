#Bitonic sorter

defmodule Bitonic do

  def comp(low, high) do spawn(fn() -> comp(low, high, 0) end)
  #Båda tal måste vara av samma epoch och vi läer epoken enbart i rätt ordning
  def comp(low, high, n)
    receive do
      {:done, ^n} ->
        send(low, {:done, n})
        send(high, {:done, n})
      {:epoch, ^n, x} ->
        receive do
          {:epoch, ^n, y} ->
            if x < y do
              send(low, {:epoch, n, x})
              send(high, {:epoch, n, y})
            else
              send(low, {:epoch, n, y})
              send(high, {:epoch, n, x})
            end
            comp(low, high, n+1)
        end
    end
  end

  def start(sinks) do
    spawn(fn() -> init(sinks) end)
  end

  def init(sinks) do
    netw = setup(sinks)
    sorter(0, netw)
  end

  #tar ett tal n, och ett nätverk (lista av PIDs)
  def sorter(n, netw) do
    receive do
      #om vi får en request att sortera en specifik epoch
      {:sort, this} ->
        #each: applicerar funktionen fun på varje element i lista
        #zip(list1, list2) returnerar en lista av tupler som består av elemenpar från båda listor
        each(zip(netw, this)),
          #funktionen tar en tuppel med {PID, ?}
          fn({pid, x}) -> send(pid, {:epoch, n, x} end)
          sorter(n+1, netw)
      :done ->
        each(netw, fn(pid) -> send(pid, {:done, n}) end)
  end

end
