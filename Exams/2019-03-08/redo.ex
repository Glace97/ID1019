#Redo questions meed oklarheter
defmodule Redo do
#Fråga 3: Balanserade träd
  @type tree() :: :nil | {:node, any(), tree(), tree()}

  def balance(:nil) do {0,0} end
  def balance({:node, _, l, r}) do
    {dl, imblnc_l} = balance(l)
    {dr, imblnc_r} = balance(r)

    depth = max(dl, dr) + 1 # +1 one for each iteration
    imblnc = max(max(imblnc_l, imblnc_r), abs(dl-dr))
    {depth, imblnc}

  end

end
