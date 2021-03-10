#Frråga 9, skriv en concurrent HP35 räknare

defmodule Hpconc do

  #spawn process with empty stack
  def init() do
    spawn(fn -> hp35([]) end)
  end

  def hp35(stack) do
    receive do
      {:add, from} ->
        [x, y | bottom] = stack
        new_stack = [x+y|bottom]  #genom detta behöver vi inte skicka tillbaka någon int via proces
        send(from, {:res, x+y})
        hp35(new_stack)
      {:int, int} ->
        hp35([int|stack])
    end
  end

  def test() do
    #start process
    hp = init()
    send(hp, {:int, 3})
    send(hp, {:int, 2})
    send(hp, {:add, self()})
    receive do
      {:res, res} -> res
    end
  end

end
