#Fråga 2.2

defmodule Tailsum do

  #skriv sumeringen svansrekursivt
  def sum(lst) do sum(lst, 0) end

  def sum([h|t], acc) do
    sum(t, h+acc)
  end
  def sum([], acc) do acc end
end
