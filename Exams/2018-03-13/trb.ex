# givet tillståndsdiagara, impl process som har det önskvärda beteendet

defmodule Trb do
  def start() do
    spawn(fn -> closed() end)
  end

  def closed() do
    IO.puts("IN CLOSED")

    receive do
      {:int, 2} ->
        two()

      # not 2
      {:int, x} ->
        closed()
    end
  end

  def two() do
    IO.puts("IN TWO")

    receive do
      {:int, 2} ->
        two()

      {:int, 4} ->
        four()

      # anything but 2 and 4
      {:int, x} ->
        closed()
    end
  end

  def four() do
    IO.puts("IN FOUR")

    receive do
      {:int, 6} ->
        six()

      {:int, 2} ->
        two()

      {:int, x} ->
        closed()
    end
  end

  def six() do
    IO.puts("IN SIX")

    receive do
      {:int, 2} ->
        two()

      {:int, x} ->
        closed()
    end
  end
end
