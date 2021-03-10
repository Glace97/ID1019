#Fråga 5: Pascals triangel
# pascal(n) där n > 0 returnerar n:the raden i triangel

defmodule Pascal do

  #start of triangel
  def pascal(1) do [1] end
  def pascal(n) do pascal(n-1, pascal(1)) end


  def pascal(0, row) do row end
  #n and previous row
  def pascal(n, prev) do
    #always start with 1
    row = [1]
    row = check_prev(prev, row)
    pascal(n-1, row)
  end

  def check_prev([b | [] ], row) do
    #last element always = 1
    row ++ [1]
  end
  def check_prev([a, b|t], row) do
    el = a + b
    row = row ++ [el]
    check_prev([b|t], row)
  end
end

#skriv en bättre variant?
