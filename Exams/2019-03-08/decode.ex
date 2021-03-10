#Fråga 1: decode; ta kodad sekvens och returnera avkodad sekvens

defmodule Decode do

  def decode(lst) do decode(lst, []) end
  def decode([], acc) do rev(acc) end
  def decode([h|rest], acc) do
    {c, f} = h
    acc = add(c, f, acc)
    decode(rest, acc)
  end

  def add(_, 0, acc) do acc end
  def add(c, f, acc) do
    add(c, f-1, [c|acc])
  end

  def rev(lst) do rev(lst, []) end
  def rev([], rev) do rev end
  def rev([h|t], rev) do
    rev(t, [h|rev])
  end

#############################
#Bättre/ enklare lösning

  def decode_better([{char, 0}| rest ]) do
    decode(rest)
  end
  def decode_better([{char, n}| rest ]) do
    [char | decode([{char, n-1}|rest])]
  end

end
