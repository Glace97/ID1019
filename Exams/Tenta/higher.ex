
defmodule Higher do

  def test() do
    fun =
      (fn(x, {:sofar, limit, acc}) ->
        if len(acc) == limit do
          {:no, reverse(acc)}
        else
          {:cont, {:sofar, limit, [x|acc]}}
        end
      end)

    lst = [1,2,3,4,5,6,7,8]
  #initial value
  take(lst, {:sofar, 5, []}, fun)
  limit = sum(lst, 10)
  take(lst, {:sofar, limit, []}, fun)
end


  def sum(lst, limit) do sum(lst, limit, 0, 0) end
  def sum([h|t], limit, sum, range) when h+sum < limit do
    sum(t, limit, sum+h, range+1)
  end
  def sum(_, _, _, range) do range end



  def take([h|t], {:sofar, limit, acc}, fun) do
    case fun.(h, {:sofar, limit, acc}) do
      {:cont, {_, _, acc}} ->
        take(t, {:sofar, limit, acc}, fun)
      {:no, res} ->
        res
    end
  end

  def len(lst) do len(lst, 0) end
  def len([], len) do len end
  def len([h|t], counter) do
    len(t, counter+1)
  end

  def reverse(lst) do reverse(lst,[]) end
  def reverse([], rev) do rev end
  def reverse([h|t], rev) do
    reverse(t, [h|rev])
  end


end
