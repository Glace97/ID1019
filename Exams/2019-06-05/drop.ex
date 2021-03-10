#Fråga 1
# drop/2 tar en lista, och ett tal <- n > 0, där var n:te tal tagits bort ur lista
defmodule Drop do

  def drop(lst, n) do drop(lst, n, 1) end
  def drop([], _n, _runs) do [] end
  def drop([h|t], n, runs) do
    if(rem(runs, n) == 0) do
      drop(t, n, runs + 1)
    else
      [h | drop(t, n, runs + 1)]
    end
  end

end
