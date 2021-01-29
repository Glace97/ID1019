defmodule Lst do
  ## :nil {:cons, head, tail}
  #define list using tuples
  def append(:nil, y) do y end
  def append({:cons, head, tail}, y) do
    {:cons, head, append(tail, y)}
  end

end
