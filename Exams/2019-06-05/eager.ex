#bara för att testa runt lite
defmodule Eager do
  def fib(n) do
    1526
  end

  def test(one, two) do
    if one > 10 do
      two
    else
      one
    end
  end

  def trial() do
    test({10}, {:hello})
  end
end
