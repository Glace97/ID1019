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


  ########################

  def foldp([x|[]], _, mother) do send(mother, {:res, x}) end #foldp på ett elementet returnerar elementet själv

  def foldp(lst, op, my_mother) do
    mother = self()
    {a,b} = split(lst)
    spawn(fn() -> foldp(a, op, mother) end)
    spawn(fn() -> foldp(b, op, mother) end)
    #moderprocessen väntar på att de två subprocesserna skickar sina svar
    receive do
      {:res, x} ->
        receive do
          {:res, y} ->
            res = op.(x,y)
            #skickar till sin moderprocess
            send(mother, {:res, res})
        end
    end


  end

  def split([], l, r) do {l, r} end
  def split(lst) do split(lst, [], []) end
  def split([h|t], l , r) do
    split(t, [h|r], l)
  end


  def test() do
    sum = fn(x,y) -> x+y end
    lst = [1,2,3,4,5,6,7]
    me = self()
    foldp(lst, sum, me)

    receive do
      {:res, res} ->
        res
    end
  end
end
