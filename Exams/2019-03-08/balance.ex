#Fråga tre "balance"
defmodule Balance do
  @type tree() :: :nil | {:node, any(), tree(), tree()}

  def balance(:nil) do {0,0} end
  def balance({:node, _, l, r}) do
    {dl, il} = balance(l)
    {dr, ir} = balance(r)
    depth = max(dl, dr) + 1 #+1 for root node
    #imbalance is; differnces in depth, or imbalance in left/right subtree
    imbalance = max(max(il, ir), abs(dl-dr))
    {depth, imbalance}
  end

end
