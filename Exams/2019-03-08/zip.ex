#fråga 2: tar två listor, x och y: avc samma längd och returnerar en lista där i:te elementet är en type, {xi, yi}
defmodule Zip do
  
  def zip([], []) do [] end
  def zip([x | tx], [y| ty]) do
    [{x, y}| zip(tx, ty)]
  end

end
