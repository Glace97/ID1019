defmodule Optimize do


#timecomplexity: size of tree is n deep (recursive call until n resources is done)
# each level has 2^n nodes
#time xomplexity seraching through entire tree -> O(2^n) incredibly slow

#@spec search(integer, integer, hinge, latch) :: {integer, integer, integer}
#given amount of material, time and price of hinges and latches
#returns number of hinges and latches to produce maximum profit --> {h, l, p}

  #-----------------alternative solution, use memory, dynamic programming-----------------------
  def memory(material, time, hinge, latch) do
    mem = Memory.new()
    #do a search, with emomry, return solution with uppated memory
    {solution, _} = search(material, time, hinge, latch, mem)
    solution
  end

  #check looksuo in memory, key = material and time, {m,t}
  def check(material, time, hinge, latch, mem) do
    case Memory.lookup({material, time}, mem) do
      nil ->
        ## no previous solution found -> search, and store in memory
        {solution, mem} = search(material, time, hinge, latch, mem)
        {solution, Memory.store({material, time}, solution, mem)}  #return solution and updated memory

      found ->
        {found, mem}
      end
  end

  #when we have enough material for hinge answell as latch
  def search(m, t , {hm, ht, hp} = h, {lm, lt, lp} = l, mem) when (m >= hm) and (t >= ht) and (m >= lm) and (t >= lt) do
    {{hi, li, pi}, mem} = check(m-hm, t-ht, h, l, mem)
    {{hj, lj, pj}, mem} = check(m-lm, t-lt, h, l, mem)
    if (pi+hp) > (pj+hp) do
      {{hi+1, li, pi + 1}, mem}
    else
      {{hj, lj+1, pj + 1}, mem}
    end
  end

  #enough material for hinge
  def search(m, t, {hm, ht, hp}=h, l, mem, module) when ((m >= hm) and (t >= ht)) do
    {{hn, ln, p}, mem} = check((m-hm), (t-ht), h, l, mem)
    {{hn+1, ln, (p+hp)}, mem}
  end

  #enough material for latch
  def search(m, t, h, {lm, lt, lp}=l, mem, module) when ((m >= lm) and (t >= lt)) do
    {{hn, ln, p}, mem} = check((m-lm), (t-lt), h, l, mem)
    {{hn, ln+1, p+lp}, mem}
  end

  #not enough material for neither
  def search(_, _, _,  _, mem)  do
    {{0,0,0}, mem}
  end

end

defmodule Memory do

  def new() do [] end

  def store(k, v, mem) do
    [{k, v}|mem]
  end

  #O(n)
  def lookup(_, []) do nil end
  def lookup(k, [{k,v}|_]) do v end
  def lookup(k, [_|rest]) do
    lookup(k, rest)
  end

end

