defmodule Recursion do

  def fib(0) do
    0
  end

  def fib(1) do
    1
  end

  def fib(n) do
    fib(n-1) + fib(n-2)
  end

  def ackerman(0,n) do
    n+1
  end

  def ackerman(m,0) do
    if m > 0 do
      ackerman(m-1, 1)
    end
  end

  def ackerman(m,n) do
    ackerman(m-1, ackerman(m,n-1))
  end

end
