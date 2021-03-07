
defmodule Redo do

  def init() do
    spwan(fn ->  process() end)
  end

  def process() do
    send(self(), :hello)
    receive do
      :hello -> :ok
    end
  end
end
