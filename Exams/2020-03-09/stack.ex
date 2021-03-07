defmodule Stack do
  @type stack() :: [any()]

  def push(el, stack) do
    [el | stack]
  end

  #popping empty stack
  def pop([]) do :no end
  def pop([top|bottom]) do
    {:ok, top, bottom}
  end
end
