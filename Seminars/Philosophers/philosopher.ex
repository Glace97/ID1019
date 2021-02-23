defmodule Philosopher do
  @dreaming 1000
  @delay 500
  #process sleeps for ( a random) time in miliseconds.
  def sleep(0) do :ok end
  def sleep(t) do
    :timer.sleep(:rand.uniform(t))
  end


  #spawns a philosopher process, start of by thinking
  def start(hunger, left, right, name, ctrl, seed) do
    spawn_link(fn -> init(hunger, left, right, name, ctrl, seed) end)
  end

  #set seed and start dreaming
  def init(hunger, left, right, name, ctrl, seed) do
    :rand.seed(:exs1024, {seed, seed, seed})
    think(hunger, left, right, name, ctrl)
  end

  def think(hunger, left, right, name, ctrl) do

    IO.puts("#{name} is dreaming")
    #sleep for randomized time, decrease time to "create" deadlock
    sleep(@dreaming)
    IO.puts("#{name} is now hungry")
    get_chopstick(hunger, left, right, name, ctrl)
  end

  def get_chopstick(hunger, left, right, name, ctrl) do
    wait = 1000; #maximum time of waiting for chopstick
    IO.puts("#{name} reaches for left chopstick")
    #artifical delay between getting chopsticks creates deadlock
    case Chopstick.request(left, wait) do
      :ok ->
        IO.puts("#{name} gets left chopstick")
        sleep(@delay)
        IO.puts("#{name} reaches for right chopstick")
        case Chopstick.request(right, wait) do
          :ok ->
            IO.puts("#{name} gets right chopstick, and can now eat!")
            eat(hunger-1, left, right, name, ctrl)
          :no ->
            IO.puts("#{name} waited too long for right chopstick")
              #go back to thinking
            think(hunger, left, right, name, ctrl)
        end
      :no ->
        IO.puts("#{name} waited too long for left chopstick")
        #go back to thinking
        think(hunger, left, right, name, ctrl)
    end
  end


  def eat(hunger, left, right, name, ctrl) do
    IO.puts("#{name} starts eating")
    #wait while eating
    sleep(@delay)
    done_eating(hunger, left, right, name, ctrl)
  end

  def done_eating(hunger, left, right, name, ctrl) do
    IO.puts("#{name} is done eating for now. Puts away chopsticks")
    Chopstick.return(left)
    Chopstick.return(right)
    if(hunger == 0) do
      IO.puts("#{name} is full and wont eat ever again")
      send(ctrl, :done)
    else
      think(hunger, left, right, name, ctrl)
    end
  end

  def ctrl() do
    receive do
      :done ->
        Process.exit(self(), :kill)
    end
  end

end
