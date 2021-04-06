#2 olika processer tar emot meddelande och skickar meddelande mellan varandra

defmodule Ping do

  def start() do
    #process for foo
    foo = spawn(fn() -> init(self()) end)
    #process for bar
    bar = spawn(fn() -> ping(:bar, foo) end)
    send(foo, {:connect, bar})
  end

  #kör i foo processen, bar ready to connect
  def init(foo) do
    receive do
      {:connect, bar} ->
        ping(:foo, bar)
    end
  end

  def ping(name, pid) do
    receive do
      #meddelande jag ska forward
      {:frw, msg} ->
        send(pid, {:msg, msg})
      #meddelande jag tar emot
      {:msg, msg} ->
        print(name, msg)
        ping(name, pid)
      :terminate ->
        :ok
    end
  end


  def print(name, msg) do
    IO.puts("#{name} received #{msg}\n")
  end
end
