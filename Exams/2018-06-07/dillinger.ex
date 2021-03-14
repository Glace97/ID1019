#Fråga 6:Givet en FSM, impl dillinger/0 som startar en sådan process

defmodule Dillinger do

  def dillinger() do
    spawn(fn -> nyc() end)
  end

  def nyc() do
    IO.puts("Hey Jim!")
    receive do
      :knife ->
        knife()
    end
  end

  def knife() do
    IO.puts("IN KNIFE")
    receive do
      :fork ->
        fork()
    end
  end

  def fork() do
    IO.puts("IN FORK")
    receive do
      :bottle ->
        bottle()
    end
  end

  def bottle() do
    ("IN BOTTLE")
    receive do
      :cork ->
        nyc()
    end
  end

end
