#slask för concurrency och parallellism

defmodule Para do

  #denna lösning spawnar för många preccer
  def fib(0) do 0 end
  def fib(1) do 1 end

  def fib(n) do
    me = self()

    spawn(fn() ->  res1 = fib(n-1); send(me, {:res, res1}) end)
    spawn(fn() -> res2 = fib(n-2); send(me, {:res, res2}) end)

    receive do
      {:res, x} ->
        receive do
          {:res, y} ->
            x+y
        end
    end
  end

  #en bättre lösning

  def fib_better(0) do 0 end
  def fib_better(1) do 1 end
  def fib_better(n) do
    r1 = make_ref()
    r2 = make_ref()

    #skicka funktion som utför op och taggar svaret
    parallell(fn() -> fib(n-1) end, r1)
    parallell(fn() -> fib(n-2) end, r2)
    f1 = collect(r1)
    f2 = collect(r2)
  end

  def parallell(fun, ref) do
    me = self()
    #utför detta parallelltt
    spawn(fn() ->
      res = fun.()
      send(me, {:ok, res, ref})
    end)
  end

  def collect(ref) do
    receive do
      {:ok, res, ^ref} -> res
    end
  end
end
