#mutex, (mutual exclusion): limit concurrency during a critical section
#modify data str and do not let any other process se until we are completely done
#not as useful in elixir as we do not modify datastr.

#impl lockprocess
defmodule Cell do

  #create a new cell
  def new() do spawn_link(fn -> cell(:open) end) end

  #defp, this function is only used under the hood in Cell module
  defp cell(state) do
    receive do
      #get current state of cell (open/closed?)
   #   {:get, from} ->
        #send process with state
    #    send(from, {:ok, state})
    #    cell(state)

    #modification will read and write to cell in same operation
    #use atomic swap
    {:swap, value, from} ->
      send(from, {:ok, state})
      cell(value)

      #set a state of cell
      {:set, value, from} ->
        send(from, :ok)
        cell(value)
      end
  end

#peterson algorithm
#first process will call lock(0, p1, p2, q)
#p1 and p2 and q = cells.
#p1, first process declare intrest in moving into critical section, and then p2 for second process
#q determines winner/draw
def lock(id, m, p, q) do
  Cell.set(m, true)
  other = rem(id + 1, 2)
  Cell.set(q, other)

  case Cell.get(p) do
    false ->
      :locked
    true ->
      case Cell.get(q) do
        ^id ->
          :locked
        ^other ->
          lock(id, m, p, q)
      end
  end
end

def unlock(_id, m, _p, _q) do
  Cell.set(m, false)
end





  #interface functions,hide the fact we're doing it asynchronic
  def get(cell) do
    send(cell, {:get, self()})
    receive do
      {:ok, state} -> state
    end
  end

  def set(cell, value) do
    send(cell, {:set, value, self()})
    receive do
      :ok -> :ok
    end
  end



  #now use cell to lock the thing we're doing?
  #def do_it(thing, lock) do
    #this case could not guarente us locked part
    #case Cell.get(lock) do


     case swap(lock, :taken) do
      :taken ->
        do_it(thing, lock)
      :open ->
        Cell.set(lock, :taken)
        do_ya_critical_thing(thing)
        Cell.set(lock, :open)
    end
  end


end
