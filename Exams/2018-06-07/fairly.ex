defmodule Fairly do
  @type tree() :: :nil | {:node, tree(), tree()}

  def fairly(:nil) do {:ok, 0} end
  def fairly({:node, l, r}) do
    {_, dl} = fairly(l)
    {_, dr} = fairly(r)
    depth = max(dl, dr) + 1
    diff = abs(dl - dr)

    if(diff <= 1) do
      {:ok, depth}
    else
      :no
    end
  end

end
