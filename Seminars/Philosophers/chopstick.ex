defmodule Chopstick do

  #start process, stick = PID (process identifier)
  def start do
    stick = spawn_link(fn -> available() end)
    {:stick, stick}
  end

  #in avaiable state, if request sent for stick, send granted
  #stick is "gone"
  def available() do
      receive do
      {:request, from} ->
        send(from, :granted)
        gone()
      :quit -> :ok
      end
  end

  #from gone state, -> either return to available or quit
  def gone() do
    receive do
      :return -> available()
      :quit -> :ok
    end
  end


#--------user interface--------, given stick
  def request({:stick, pid}) do
    #send process, with request
    send(pid, {:request, self()})
    #if granted, then ok
    receive do
      :granted -> :ok
    end
  end

  #modified request, specify time we are willing to wait
  #not sure this is working
  def request({:stick, pid}, timeout) do
    send(pid, {:request, self()})
    receive do
      :granted ->
        :ok
    after
      timeout ->
        :no
    end
  end

  #send return req
  def return({:stick, pid}) do
    send(pid, :return)
  end

  def quit({:stick, pid}) do
    send(pid, :quit)
  end
end
