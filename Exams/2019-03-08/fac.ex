#fråga 8, fakultet
defmodule Fac do
  #returnerar n fakultet
  def fac(1) do 1 end
  def fac(n) do
    n * fac(n-1)
  end

  #tar ett tak n, returnerar fakultet på LINJÄR TID
  #OBS, vi kan inte använda fac funktionen (då vi inte kan garantera linjär tid)

  def facl(1) do [1] end
  def facl(n) do facl(n, [1] , 2) end
  def facl(n, fac, n) do fac end
  def facl(n, [h|t], counter) do
    lst = [h|t]
    facl(n, [counter * h |lst], counter+1) #funktionsanrop n-1
  end


  #facits lösning
  def facl_better(1) do [1] end
  def facl_better(n) do
    rest = facl_better(n-1)
    [f | _] = rest
    [n*f|rest]
  end


end
