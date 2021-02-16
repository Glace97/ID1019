defmodule Cards do
 # @type suite() :: :spade | :heart| :diamond |:club
 # @type value: 2|3|4|5|6|7|8|9|10|11|12|13|14
 # @type card() :: {:card, suite(), value()}

 def test() do
  deck = [{:card, :heart, 5},
  {:card, :heart, 7},
  {:card, :spade, 2},
  {:card, :club, 9},
  {:card, :diamond, 5}]
  msort(deck, fn(c1,c2) -> lt(c1,c2) end)
 end

 #less than
 #is first card less than second?
 # soade -> hjärter -> ruter -> klöver
 def lt({:card, s, v1}, {:card, s, v2}) do v1 < v2 end

 #klöver är minsta kortet, kolla korten i ordning
 def lt({:card, :club, },_) do true end

 def lt({:card, :diamond, _},{:card, :heart, _}) do true end

 def lt({:card, :diamond,_}, {:card, :spade, _}) do true end

 def lt({:card, :diamond, _},{:card, :heart, _}) do true end

 def lt({:card, :heart, _},{:card, :spade, _}) do true end

 #catch all
 def lt({:card, _, _},{:card, _, _}) do false end

#sorting of cards, with operation sort function is general
 def msort([], _) do [] end
 def msort([c], _) do [c] end
 def msort(lst, op) do
   {a, b} = msplit(lst, [], [])    #tuple of two lists, wich will be left half and right half
   merge(msort(a, op), msort(b, op), op) #merge sorted left partition with right
 end

 #merge two sorted lists, pick only need to look at first element of each list
 def merge(l1, [], _) do l1 end
 def merge([], l2, _) do l2 end
 def merge([c1|t1], [c2|t2], op) do
  if op.(c1,c2) do
      [c1|merge(t1, [c2|t2], op)]
  else
      [c2|merge([c1|t1],t2, op)]
  end
 end

 #split function
 def msplit([],l1,l2) do {l1,l2} end
 def msplit([c|t], l1, l2) do
    msplit(t, [c|l2], l1) #every other turn, l1 and l2 is switched, until list is empty
 end
end
