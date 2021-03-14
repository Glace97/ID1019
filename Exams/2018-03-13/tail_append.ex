#Svansrekursiv append mha reverse som implementeras svansrekursivt

defmodule Tailapp do

  def rev(lst) do rev(lst, []) end
  def rev([], rev) do rev end
  def rev([h|t], rev) do
    rev(t, [h|rev])
  end

  def append([], final) do final end
  #list1 will be reversed
  def append([h|t], lst2) do
    append(t, [h|lst2])
  end
  def rev_append(lst1, lst2) do
    rev = rev(lst1)
    append(rev, lst2)
  end


  #alternativ lösning (från facit)
  def append_better(a,b) do rev(rev(a), b) end
end
