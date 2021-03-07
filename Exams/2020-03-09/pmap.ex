# parallell maps
# map(enumerable, fun)
# Returns a list where each element is the result of invoking fun on each corresponding element of enumerable.
defmodule Pmap do

  def pmap(list, func) do
    #mappa en referense till varje element i listan
    refs = Enum.map(list, paralell(func))

    #mappa resultatet till varje referens
    Enum.map(refs, collect())
  end

  #parallell ska
  # 1. skapa en unik referens till varje element i listan och OMEDELBART skicka tillbaka
  # 2. skapa en process till varje element i lista och utföra func.operation
  def paralell(func) do

    #moderprocessen (pmap funktionsanrop)
    me = self()

    #skapa och skicka iväg process till trådpool, may or may not göras i ordning/ eller paralellt
    fn(x) ->
      ref = make_ref()    #tagga nyskapad process, return unique refrence
      spawn(fn() ->
        res = func.(x) #operationen gjord på elementet

        #skicka nu, denna process med references och resultet
        send(me, {:ok, ref, res})
      end)

    ref #returnera referensen omedelbart oavsett om processen är färdig
    end
  end

  #returnera ett resultat för en given referens
  def collect() do
    #receive väntar tills den får meddelandet
    fn(r) -> receive do {:ok, ^r, res} -> res end end
  end
end
