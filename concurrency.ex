defmodule Wait do

  #start a process by spawn(module, atom/string, [])
  #send process with input; send process, input
  #register a process to atom by Process.register(p, :foo), then; send :foo, message
  def hello do
    receive do
      x -> IO.puts("aaa! surprise, a message: #{x}")
    end
  end


end


#send more complex datastructures
defmodule Tic do
  def first do
    receive do
      {:tic, x} ->
        IO.puts("tic: #{x}")
        second()
    end
  end


  defp second do
    receive do
      {:tac, x} ->
        IO.puts("tac: #{x}")
        last()
      {:toe, x} ->
        IO.puts("toe: #{x}")
        last()
    end
  end

  defp last do
    receive do
      {:tic, x} ->
        IO.puts("tic: #{x}")
      {:tac, x} ->
        IO.puts("tac: #{x}")
      {:toe, x} ->
        IO.puts("toe: #{x}")
    end
  end
end
