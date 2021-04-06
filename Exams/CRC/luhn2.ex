#räkna ut kontrollsiffran längst ner i personnuret

defmodule Luhn do

  def luhn(lst) do

    #first element *2, second *1 and so forth
    multiplied = multiply(lst, 2)
    sum = add_seq(multiplied) #added sequence

    control = 10 - rem(sum, 10)

  end

  def add_seq(lst) do add_seq(lst, 0) end
  def add_seq([], sum) do sum end
  #h never larger than 20
  def add_seq([h|t], sum) when h > 9 do
    x = rem(h, 10)
    sum = sum + 1+ x
    add_seq(t, sum)
  end
  def add_seq([h|t], sum) do
    add_seq(t, h+sum)
  end

  def multiply([], _) do [] end
  #alterante mellan dessa två
  def multiply([h|t], 1) do
    [h*1 | multiply(t, 2)]
  end
  def multiply([h|t], 2) do
    [h*2 | multiply(t, 1)]
  end

end
