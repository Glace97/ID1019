 defmodule Queue do

  #func creates datastructure of a queue
  #def new() do [] end <- naive solution
  def new() do {:queue, [], []} end   #{queue, front, [elem|back]}

  #implement a queue, FIFO
  #add to back of queue
  def add({:queue, front, back}, elem) do {:queue, front, [elem|back]} end

  #remove from front, return tuple of current queue
  def remove({:queue, [], []}) do :error end
  def remove({:queue, [], back}) do
    remove({:queue, reverse(back), []})
  end

  def remove({:queue,[elem|rest], back}) do
    {:ok, elem, {:queue, rest, back}}
  end

  #helper func
  def reverse(lst) do reverse(lst, []) end
  def reverse([], rev) do rev end
  def reverse([h|t], rev) do reverse(t, [h|rev]) end
  #---------naive solution---------
  # def add([], elem) do [elem] end
  # def add([h|t], elem) do
  # [h | add(t, elem)]
  # end

  # def remove([]) do :error end
  # def remove([h|t]) do
  #    {:ok, h, t}
  #  end
  end
