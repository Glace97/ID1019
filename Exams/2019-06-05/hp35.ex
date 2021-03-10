

defmodule Hp do

 #Fråga 4, omvänd polsk notation för addition och subtraktion
  @type op() :: :add | :sub
  @type instr() :: integer() | op()
  @type seq() :: [instr()]
  @spec hp35(seq()) :: integer()

  def hp35(seq) do hp35(seq, []) end

  def hp35([], stack) do stack end
  def hp35([h|t], stack) do
    case h do
      :add ->
        {_, a, updated} = pop(stack)
        {_, b, stack} = pop(updated)
        res = b + a
        new_stack = push(res, stack)
        hp35(t, new_stack)
      :sub ->
        {_, a, updated} = pop(stack)
        {_, b, stack} = pop(updated)
        res = b - a
        new_stack = push(res, stack)
        hp35(t, new_stack)
      integer ->
        new_stack = push(integer, stack)
        hp35(t, new_stack)
    end
  end

  #helper functions
  def push(el, stack) do
    [el|stack]
  end

  def pop([h|stack]) do
    {:ok, h, stack}
  end

end
