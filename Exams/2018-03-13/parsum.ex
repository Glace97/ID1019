#sum/1 tar ett träd med tal i löven och summerar alla talen i trädet parallellt

defmodule Parsum do
  @type tree() :: :nil | {:node, integer(), tree(), tree()}

  def sum(:nil) do 0 end
  def sum({:node, val, l, r}) do
    me = self()
    spawn(fn() -> l_sum = sum(l); send(me, {:res, l_sum}) end)
    spawn(fn() -> r_sum = sum(r); send(me, {:res, r_sum}) end)

    receive do
      {:res, suml} ->
        receive do
          {:res, sumr} ->
            sum = suml + sumr + val
        end
    end
  end

end
