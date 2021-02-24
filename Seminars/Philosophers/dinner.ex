defmodule Dinner do
  def start(), do: spawn(fn -> init() end)

  def init() do
    seed = 9874
    c1 = Chopstick.start()
    c2 = Chopstick.start()
    c3 = Chopstick.start()
    c4 = Chopstick.start()
    c5 = Chopstick.start()
    ctrl = self()
    #each philosopher has a unique seed value
    Philosopher.start(5, c1, c2, "Arendt", ctrl, 3, seed)
    Philosopher.start(5, c2, c3, "Hypatia", ctrl, 3, seed + 1)
    Philosopher.start(5, c3, c4, "Simone", ctrl, 3, seed + 2)
    Philosopher.start(5, c4, c5, "Elisabeth", ctrl, 3, seed + 3)
    Philosopher.start(5, c5, c1, "Ayn", ctrl, 3, seed + 4)
    wait(5, [c1, c2, c3, c4, c5])
  end


  def wait(0, chopsticks) do
    IO.puts"All philosophers are done eating"
    Enum.each(chopsticks, fn(c) -> Chopstick.quit(c) end)
  end

  #if things go wrong and process terminates with error
  #kill all linked processes
  def wait(n, chopsticks) do
    receive do
    :done ->
      wait(n - 1, chopsticks)
    :abort ->
      Process.exit(self(), :kill)
    end
  end

end
