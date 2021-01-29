defmodule M do
  def celcius(f) do
    c = ((f-32)/1.8)
  end

  def reqarea(x, y) do
    area = x*y
  end

  def sqarea(x, y) do
    if x==y do
      reqarea(x,y)
    else 
      IO.puts("Not a square")
    end
  end
end
