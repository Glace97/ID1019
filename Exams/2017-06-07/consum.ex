
defmodule Consum do

  def start() do
   spawn(fn() -> value(0) end)
  end

  #val körs i processen som kommer
  def value(val) do
    receive do
      {:add, n} ->
        value(val+n)
      {:sub, n} ->
        value(val-n)
      {:req, pid} ->
        send(pid, {:total, val})
        value(val)
    end
  end

  def test() do
    calculate = start()
    me = self()
    #a couple of operations
    send(calculate, {:add, 3})
    send(calculate, {:add, 8}) #should be 6
    send(calculate, {:sub, 1}) # should be 5
    send(calculate, {:req, me})

    #inbox
    receive do
       {:total, val} ->
        {:ok, val}
    end

  end


end
