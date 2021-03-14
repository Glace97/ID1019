#en form av parallell fold.
# 1. Dela upp listan i två lika stora delar
# 2. kör fold på vardera lista, parallellt
# 3. applicera funktionen/operationen vi har på resultatet av vardera lista
# 4. Inget initialt värde -> antag därför minst ett elemnt i listan, foldp om n= 1 är elementet själv
# Denna kod går inte att testa, för någon anlednning

defmodule Foldp do

  def foldp([x]) do x end
  def foldp(lst, op) do
    #split list into two halves
    {l, r} = split(lst)
    me = self() #moderprocessen

    #skapa separata processer för varje fold
    #folds skickar svaret tillbaka till moderprocessen
    spawn(fn() -> res = foldp(l, op); send(me, {:res, res}) end)
    spawn(fn() -> res = foldp(r, op); send(me, {:res, res}) end)

    #vänta på resultat frånd dessa folds
    receive do
      {:res, r1} ->
        receive do
          {:res, r2} ->
            op.(r1, r2)
        end
    end
  end


  def split(lst) do split(lst, [], []) end
  def split([], l, r) do {l, r} end
  def split([h|t], l, r) do
    split(t, r, [h|l])
  end
end
