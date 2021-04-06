#Fråga 2.1

defmodule Transf do

  #x och y ett tal, l en lista
  #returnera en lista där alla tal x tagits bort i l och resterande multiplicerats med y
  def transf(x, y, [x|t]) do
   transf(x,y,t)
  end

  def transf(x, y, [h|t]) do
    [h*y|transf(x,y,t)]
  end

  def transf(_,_,[]) do [] end
end
