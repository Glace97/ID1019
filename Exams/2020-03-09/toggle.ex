defmodule Toggle do

  #if done with list (is empty, even nr of elements)
  def toggle([]) do [] end
  #odd nr of elements
  def toggle([last|[]]) do [last] end
  def toggle([a, b | rest]) do
    [b, a | toggle(rest)]
  end

end
