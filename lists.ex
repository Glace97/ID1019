#listexcercises

defmodule Lists do

  #return first element in list
  def tak([h|t]) do h end
  def tak([]) do :no end

  #remove first element in list
  def drp([h|t]) do t end
  def drp([]) do :no end

  #return length
  def len([_|t]) do 1 + len(t) end
  def len([]) do 0 end

  #return sum
  def sum([h|t]) do h+ sum(t) end
  def sum([]) do 0 end

  #duplicates elements in list
  def duplicate(x) do
    if x == [] do
      x
    else
      [h|t] = x
    x = [h|[h|duplicate(t)]]
    end
  end

  #add x in a list if not already memeber
  def add(x, lst) do add(x, lst, lst) end
  def add(x, [], lst) do [x] ++ lst end
  def add(x, [h|t], lst) do
    if x == h do
      lst
    else
      add(x, t, lst)
    end
  end

  #remove all occurences of x from list
  def remove(x, lst) do remove(x, lst, []) end
  def remove(x, [], res) do res end
  def remove(x, [h|t],  res) do
    if x == h do
      remove(x, t, res)
    else
      remove(x, t, res ++ [h])
    end
  end

  #takes list and returns a list of all unique elements
  def unique([]) do [] end
  def unique([h|t]) do
    [h] ++ unique(remove(h,t))
  end


  #append
  #Time complexity, #recursive calls = #elements in 1st arg(list) + basecase, O(n) where n is length of 1st arg.
  #^independant of y.
  #OBS: ++ is equal to append, interchangeable, linear time
  def append([h|t], y) do
    z = append(t,y)
    [h|z]
  end
  def append([],y) do y end

  #union of two multisets (lists),(can also be calculted by append)
  #tail recursion optimazion, uses less stack space
  def union([h|t],y) do
    z = [h|y]
    union(t, z)  #last oepration is recursive call
  end
  def union([],y) do y end


  #return a tuple {odd, even}
  def odd_n_even([]) do {[],[]} end
  def odd_n_even([h|t]) do
    {o, e} = odd_n_even(t)
    if rem(h,2) == 1 do
      {[h|o], e}
    else
      {o,[h|e]}
    end
  end

  #variant off odd_n_even with accumulator, OBS:not ordered
  def add_n_even(lst) do add_n_even(lst, [], []) end #given a list, use two emply lists as accumulators
  def add_n_even([], odd, even) do {odd, even} end  #basecase
  def add_n_even([h|t], odd, even) do
    if rem(h, 2) == 1 do
      add_n_even(t, [h|odd], even)
    else
      add_n_even(t, odd, [h|even])
    end
  end

  #reverse a list (non-tail recurisve)
  #time complexity: one recursive call for each element + one append for each recursive (append -> O(n)); ie: O(n^2)
  def rev([]) do [] end
  def rev([h|t]) do
    rev(t) ++ [h]  #append head
  end

  #reverse a list with accumulator, (tail recursive)
  #time complexity: O(n), one recurisve call for each element in list
  def revacc(lst) do revacc(lst,[]) end
  def revacc([], rev) do rev end
  def revacc([h|t], rev) do
    revacc(t, [h|rev])
  end

  #flattens a list of list -> into one single list
  # k: length of each list in call(flat), n length of original list
  #time complexity: one append and recurisve call per element in head-list (see append func) O(n*k)
  def flat([]) do [] end
  def flat ([h|t]) do
    h ++ flat(t)
  end

  #flatten list of list with accumulator
  #time complexity: last append operation is expensive (full size of flat-list appended to h) n^2*k (tail recursion is costs MORE)
  def flatacc(lst) do flatacc(lst, []) end
  def flatacc([], flat) do flat end
  def flatacc([h|t], flat) do
   flatacc(t, flat ++ h)
  end



end
