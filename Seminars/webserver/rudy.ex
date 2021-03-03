#rudimentary server
defmodule Rudy do

  #let server run on different process
  def start(port) do
    Process.register(spawn(fn -> init(port) end), :rudy)
  end

  #kill named process server runs on (without killing elixir shell)
  def stop() do
    case Process.whereis(:rudy) do
      nil ->
        :ok
      pid ->
	      Process.exit(pid, "Time to die!")
    end
  end


  #initialize server and open socket
  def init(port) do
    opt = [:list, active: false, reuseaddr: true]
    case :gen_tcp.listen(port, opt) do
      {:ok, listen} ->
          handler(listen) #pass socket to handler
          :gen_tcp.close(listen)
          :ok
      {:error, error} ->
          error
    end
  end


  #listens to socket for incoming connection
  #if client connects, pass connection to request
  def handler(listen) do
    case :gen_tcp.accept(listen) do
      {:ok, client} ->
        request(client)
      {:error, error} ->
        error
    end
  end

  #reads request and parses it using HTTP parser
  def request(client) do
    recv = :gen_tcp.recv(client, 0)
    case recv do
      {:ok, str} ->
        request = HTTP.parse_request(str)  # {{:get, uri, ver}, headers, body}
        response = reply(request)
        :gen_tcp.send(client, response)
      {:error, error} ->
        IO.puts("RUDY ERROR: #{error}")
    end
    :gen_tcp.close(client)
  end

  #decide what to respond with
  def reply({{:get, uri, _}, _, _}) do
    :timer.sleep(10)  #simulate file handling
    HTTP.ok("Hello!")
  end

end
