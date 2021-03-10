#Fråga 4, evaluera aritmetiska uttryck (rknare)

defmodule Eval do
  @type expr() :: integer() |
  {:add, expr(), expr()} |
  {:mul, expr(), expr()} |
  {:neg, expr()}

  def eval({:add, a, b}) do
    eval(a) + eval(b)
  end
  def eval({:sub, a, b}) do
    eval(a) - eval(b)
  end
  def eval({:mul, a, b}) do
    eval(a) * eval(b)
  end
  def eval({:neg, expr}) do
    -expr
  end
  def eval(num) do
    num
  end


end
