defmodule Flatten do

  #facit
  def flatten([]) do [] end
  def flatten([head|tail]) do
     flatten(head) + flatten(tail)
  end
  def flatten(item) do [item] end


  #min lösning
  def flat([]) do [] end
  def flat([[lst|rest]|t]) do
    flat([lst]) ++ flat(rest) ++ flat(t)
  end
  def flat([el|t]) do
    [el] ++ flat(t)
  end


  #flatten improved with linear time
  def improved([]) do [] end
  def improved([[] | rest]) do
    improved(rest)
  end
  def improved([[head | tail] | rest]) do
    improved([head, tail | rest])
  end
  def improved([ elem | rest]) do
    [elem | improved(rest)]
  end
end
