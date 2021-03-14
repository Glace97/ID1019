#slaskmodul

defmodule Redo do

  def start(user) do
    collect = {:ok, spawn(fn() -> collect(0, user))}
    {:ok, spawn(fn() -> proc(collect, 0) end)}
  end

  def proc(collect, n) do
    receive do
    {:process, task} ->
      spawn(fn() ->
        done = doit(task)
        send(collect, {:done, done, n})
      end)
      proc(collect, n+1)
    :quit ->
      send(collector, :quit)
    end
  end

  def collect(n, user) do
    receive do
      {:done, res, ^n} ->
        send(user, res)
        collect(n+1, user)
      :quit ->
        :ok
    end
  end
end
