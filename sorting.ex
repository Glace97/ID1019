defmodule Sorting do
  #insertion sort
  def isort(lst) do isort(lst, [])end

  def isort([], sorted) do sorted end
  def isort([h|t], sorted) do
    sorted = insert(h,sorted)
    isort(t, sorted)
  end

  #inserts element in right place, ascending order
  def insert(element,[]) do [element] end
  def insert(element,[h|t]) do
    if (element < h) do
      [element,h|t]
    else
       [h] ++ insert(element,t)
    end
  end

  #------------------------------------------merge sort-------------------------------------------------
  def msort([]) do [] end
  def msort([x]) do [x] end
  def msort(lst) do
    {l1, l2} = msplit(lst, [], [])    #tuple of two lists, wich will be left half and right half
    merge(msort(l1), msort(l2)) #merge sorted left partition with right
  end

  #merge two sorted lists, pick only need to look at first element of each list
  def merge(l1, []) do l1 end
  def merge([], l2) do l2 end
  def merge([h1|t1], [h2|t2] ) do
    if h1 < h2 do
      [h1|merge(t1, [h2|t2])]
    else
      [h2|merge([h1|t1],t2)]
    end
  end

  #split function
  def msplit([],l1,l2) do {l1,l2} end
  def msplit([h|t], l1, l2) do
    msplit(t, [h|l2], l1) #every other turn, l1 and l2 is switched, until list is empty
  end

  #-------------------------------------------quicksort---------------------------------------------------
  def qsort([]) do [] end
  def qsort([p | l]) do
    {l1, l2} = qsplit(p, l, [], [])
    small = qsort(l1)
    large = qsort(l2)
    append(small, [p | large])
  end


  def qsplit(_, [], small, large) do {small, large} end
  def qsplit(p, [h | t], small, large) do
    if h < p  do
      qsplit(p, t, [h|small], large)
    else
      qsplit(p, t, small, [h|large])
    end
  end

  def append(small, p_large) do
    case small do
      [] -> p_large
      [h | t] -> [h|append(t, p_large)]
    end
  end
end
