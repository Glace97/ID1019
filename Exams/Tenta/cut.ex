defmodule Cut do

  def cut([_]) do 0 end
  def cut([s|seq]) do cut(seq, [s]) end

  def cut([l], right) do
    #
    cut(right) + l + Enum.sum(right)
  end

  def cut(left, right) do
    alt1 = cut(left) + cut(right) + Enum.sum(left) + Enum.sum(right)
    alt2 = cut(tl(left), [hd(left)|right])
    if alt1 < alt2 do
      alt1
    else
      alt2
    end
  end

end
