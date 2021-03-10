# Fråga 7: Transformera ett träd
# trans/2 tar ett träd + funktion som arg. Returnerar nytt träd som är identisk till givna trädet, men med nya värden
# impl. remit/2 som tar en träd och ett tal n, erturnerar (genom trans/2) ett träd där värde x har bytts ut mot resten av heltalsdiv

defmodule Trans do
  @type tree() :: {:node, any(), tree(), tree()} | :nil
 # @spec trans(tree(), (any() -> any()))

  def trans(:nil, _fun) do :nil end
  def trans({:node, val, l, r}, fun) do
    new_val = fun.(val)
    {:node, new_val, trans(l, fun), trans(r, fun)}
  end

  #def remit(:nil, _n) do :nil end
  def remit(tree, n) do
    fun = fn (x) -> rem(x,n) end
    trans(tree, fun)
  end

end
