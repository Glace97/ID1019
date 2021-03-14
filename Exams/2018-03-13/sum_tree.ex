#Fråga 4: sum/1 tar ett träd och returnerar summan av alla värden i trädet

defmodule Sum do
  @type tree :: {:node, integer(), tree(), tree()} | nil

  def sum(:nil) do 0 end
  def sum({:node, val, l, r}) do
    l_sum = sum(l)
    r_sum = sum(r)
    sum = l_sum + r_sum + val
  end

end
