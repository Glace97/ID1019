# Fråga 2: Rotate
# rotate/2 tar en lista, len = l och 0 < n  > l, returnerar en lista där elementet roterat n steg
# enbart använda append och reverse en enda gång per evaluering
defmodule Rotate do
  def rotate(lst, n) do rotate(lst, n, []) end

  #lösningen ej en per evaluering
  def rotate(lst, -1, _acc) do lst end
  def rotate([last |[]], n, acc) do
    tail = Enum.reverse(acc)
    rotated = [last|tail]
    IO.inspect(rotated)
    rotate(rotated, n-1, [])  #takes next
  end
  def rotate([h|t], n, acc) do
    rotate(t, n, [h|acc])
  end

end
