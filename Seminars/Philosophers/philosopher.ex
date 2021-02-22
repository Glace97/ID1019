defmodule Philosopher do

  #process sleeps for ( a random) time in miliseconds.
  def sleep(0) do :ok end
  def sleep(t) do
  :timer.sleep(:rand.uniform(t))
  end


  #spawns a philosopher process, start of by thinking
  def start(hunger, left, right, name) do
    spawn_link(fn -> think(hunger, left, right, name) end)
  end

  def think(hunger, left, right, name) do
    IO.puts("#{name} is dreaming")
    #sleep for randomized time
    sleep(10)
    IO.puts("#{name} is hungry")
    get_chopstick(hunger, left, right, name)
  end

  def get_chopstick(hunger, left, right, name) do
    IO.puts("#{name} reaches for left chopstick")
    l_chopstick = Chopstick.request(left)
    r_chopstick = Chopstick.request(right)

    case l_chopstick do
      :ok ->
        IO.puts("#{name} gets left chopstick")
        IO.puts("#{name} reaches for right chopstick")
        case r_chopstick do
          :ok -> IO.puts("#{name} gets right chopstick, and can now eat!")
          eat(hunger-1, left, right, name)
        end
    end
  end


  def eat(hunger, left, right, name) do
    IO.puts("#{name} starts eating")
    #wait while eating
    sleep(5)
    done_eating(hunger, left, right, name)
  end

  def done_eating(hunger, left, right, name) do
    IO.puts("#{name} is done eating for now. Puts away chopsticks")
    Chopstick.return(left)
    Chopstick.return(right)
    if(hunger == 0) do
      IO.puts("#{name} is full and wont eat ever again")
      send(ctrl, :done)
    else
      think(hunger, left, right, name)
    end
  end

  def ctrl() do
    receive do
      :done ->
        Process.exit(self(), :kill)
    end
  end

end
