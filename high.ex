defmodule High do
  #---------------Implemented stream-----------------
  #Given a range, certain operations are made


  #represent range of integers from 1-10
  #{:range, 1, 10}, utnyttja givna intervallet
  def sumr({:range, from, from}) do from end
  def sumr({:range, from, to}) do
    from + sumr({:range, from+1, to})
  end

  #likt/identiskt till foldl. Med skillnaden att vi utgår från intervall(ist för lista)
  def sum(range) do
    reduce(range, {:cont, 0}, fn(x,acc) ->  {:cont, x + acc} end)
  end

  #returnerar fakultet
  def prod(range) do
    reduce(range, {:cont, 1}, fn(x,acc) ->  {:cont, x * acc}  end)
  end

  #continue tuple instead of just accumulator
  #function must return an instruction
  def reduce({:range, from, to}, {:cont, acc}, fun) do
    if from <= to do
      reduce({:range, from+1, to}, fun.(from, acc), fun)
    else
      {:done, acc}
    end
  end

  #give command to reduce
  def reduce(range, {:suspend, acc}, fun) do
    {:suspended, acc, fn (cmd) -> reduce(range, cmd, fun) end}
  end

  #return first value in range
  def head(range) do
    reduce(range, {:cont, :na},
    fn(x,_) ->
      {:suspend, x}
    end)
  end

  #om vi vill stanna innan vi nått hela range
  def reduce(_, {:halt, acc}, _) do
    {:halted, acc}
  end

   #return a partion of range given a limit
   def take(range, n) do
    reduce(range, {:cont, {:sofar, 0, []}},
    fn (x, {:sofar, s, acc}) ->
      s = s+1
      if s >= n do
        {:halt, Enum.reverse([x|acc])}
      else
        {:cont, {:sofar, s, [x|acc]}}
      end
    end)
  end

  #oändlig lista
  def infinity() do
    fn() -> infinity(0) end
  end
  def infinity(n) do
    [n|fn() ->infinity(n+1) end]
  end

  #oändlig fib
  def fib() do
    fn() -> fib(1,1) end
  end
  def fib(f1, f2) do
    [f1| fn() -> fib(f2, f1+f2) end
  ]
  end

  #return the list of f.(x) for each element x in the enumeration
  #finns i enum (enumerable), mer om detta i cars modul
  def map([], _op) do [] end
  def map([h|t], op) do
    [op.(h)|map(t, op)]
  end

  #filter(enum, f): return a list of all elements x, for which f.(x) evaluates to true
  def filter([], _) do [] end
  def filter([h|t], op) do
    if op.(h) do
      [h|filter(t, op)]
    else
      filter(t,op)
    end
  end

  #split_with(enum, f): partition the enumeration based on the result of f.(x)


  #foldr funktionerna finns i List modulen
  #fold right, op = operation, någon beräkning/funktion
  # [1,2,3,4] 0 +
  # foldl (1 + (2 + (3 + ( 4 + 0))))
  def foldr([], acc, _op) do acc end
  def foldr([h|t], acc, op) do
    op.(h, foldr(t, acc, op))
  end

  #svanrekursiv fold left
  # foldl t.ex, [1,2,3,4] 0 +
  # (4 + (3 + (2 + (1 + 0))))
  def foldl([], acc, _op) do acc end
  def foldl([h|t], acc, op) do
    foldl(t, op.(h,acc), op)
  end

 #tex en flatten, vilken är mest effektiv av dessa??
 #foldr är inte svansrekursiv, men acc växer för varje anrop
 #därmed blir foldl en dyr operation
  def append_right(lst) do
    op = fn (e, acc) -> e ++ acc end
    foldr(lst, [], op)
  end

  def append_left(lst) do
    op = fn (e, acc) -> acc ++ e end
    foldl(lst, [], op)
  end

  #best of both worlds, ordningen inte detsamma
  def append_best(lst) do
    op = fn (e, acc) -> e ++ acc end
    foldl(lst, [], op)
  end

  #naive reverse
  def tomat(lst) do
    op = fn (h,a) -> a ++ [h] end
    foldr(lst, [], op)
  end

  #morot är mest effektiv
  #1. foldl är svanrekursiv
  #2. vi använder inte append, inlägg av element konstant tid
  def morot(lst) do
    op = fn (h,a) -> [h|a] end
    foldl(lst,[],op)
  end
end
