defmodule Fibstream do

  def fib() do
    fn() ->
      {:ok, 0, fn -> next(1) end}
    end
  end

  def next(n) do
    {:ok, fib(n), fn -> next(n+1) end}
  end

  def fib(0) do 0 end
  def fib(1) do 1 end
  def fib(n) do fib(n-1) + fib(n-2) end

  def take(fun, n) do take(fun, n, []) end
  def take(cont, 0, acc) do {:ok, Enum.reverse(acc), cont} end
  def take(fun, n, acc) do
    {_, fib, cont} = fun.()
    take(cont, n-1, [fib|acc])
  end

  def test() do
    cont = fib()
    {:ok, f1, cont} = cont.()
    {:ok, f2, cont} = cont.()
    {:ok, f3, cont} = cont.()
    {:ok, f4, cont} = cont.()
    {:ok, f5, cont} = cont.()
    {:ok, f6, cont} = cont.()
    [f1, f2, f3, f4, f5, f6]
  end

end
