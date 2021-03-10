#Fråga 5, greycode tar n > 0 och generar en lista med n-bitar greycode

defmodule Gray do
  def gray(0) do [[]] end
  def gray(n) do
    g1 = gray(n-1)
    IO.puts("This is g1:\n")
    IO.inspect(g1)
    r1 = Enum.reverse(g1)
    IO.puts("This is r1\n")
    IO.inspect(r1)

    greycode = update(g1, 0) ++ update(r1, 1)
    IO.puts("Greycodelist sofar\n")
    IO.inspect(greycode)
  end

  def update([], _) do [] end
  def update([h|t], b) do
    IO.puts("in updated func\n")
    IO.puts("This is head n tail\n")
    IO.inspect(h)
    IO.inspect(t)
    updated = [[b|h]| update(t,b)]
    IO.inspect(updated)
  end



end
