defmodule Arit do
  @type expr() :: const() | sum() | prod()
  @type sum() :: {:add, expr(), expr()}
  @type prod() :: {:mul, expr(), expr()}
  @type const() :: {:const, integer()}


  def eval({:add, {:const, num1}, {:const, num2}}) do
    sum = num1 + num2
  end

end
