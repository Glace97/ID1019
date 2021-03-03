defmodule Test do
  @number_requests 100

  # small benchline program generates several requests and measure time taken to receive answers
  def bench(host, port) do
    start = Time.utc_now()
    run(@number_requests, host, port)
    finish = Time.utc_now()
    diff = Time.diff(finish, start, :millisecond)
    IO.puts("Benchmark: #{@number_requests} requests in #{diff} ms")
  end

  defp run(0, _host, _port), do: :ok

  defp run(n, host, port) do
    request(host, port)
    run(n - 1, host, port)
  end

  defp request(host, port) do
    opt = [:list, active: false, reuseaddr: true]
    case :gen_tcp.connect(host, port, opt) do
      {:ok, server} ->
	      :gen_tcp.send(server, HTTP.get("/foo.html"))
	      case :gen_tcp.recv(server, 0) do
	        {:ok, _reply} ->
	          :ok
	        {:error, _reason} ->
            :error
	      end
        :gen_tcp.close(server)
      {:error, _reason} ->
	      :error
    end
  end

end
