# ---------REPRESENTING TREE------------
# LEAF NODE: {:leaf, value} or {:node, value, :nil, :nil} (last one makes program easier)
# BRANCH NODE: {:node, value, left, right}
# EMPTY TREE: :nil
# tree = {:node, :b, {leaf,:a},{:keaf, :c}}
# Asympotisk tidskomplexitet inför frågestund

defmodule Tree do

  #search member of tree
  def member(_, :nil) do :no end
  def member(elem, {:leaf, elem}) do :yes end
  def member(_, {:leaf, _}) do :no end
  def member(elem, {:node, elem, _, _}) do :yes end

  #ordered tree(smallest left)
  def member(elem, {:node, e, left, right}) do
    if elem < e do
      member(elem, left)
    else
      member(elem, right)
    end
  end

  @unordered_tree"""
  def member(elem, {:node, _, left, right}) do
    case member(elem, left) do
      :yes -> :yes
      :no -> case member(elem, right) do
        :yes -> :yes
        :no -> :no
      end
    end
  end
  """
end

#module with Leaf =  {:node, value, :nil, :nil}
#assume ordered(!!) tree of key-value pairs
#tree = {:node, :key, value, left, right}
defmodule Tree2 do

  #lookup a value given key argument
  def lookup(key, :nil) do :no end
  def lookup(key, {:node, key, value, _, _}) do {:value, value} end
  def lookup(key, {:node, k, _, left, right}) do
    if key < k do
      lookup(key, left)
    else
      lookup(key, right)
    end
  end

  #modify value given key arg
  def modify(_, _, :nil) do :nil end
  def modify(key, value, {:node, key, _, left, right}) do
    {:node, key, value, left, right}
  end
  def modify(key, value, {:node, k, v, left, right}) do
    if key < k do
      {:node, k, v, modify(key, value, left), right}
    else
      {:node, k, v, left, modify(key, value, right)}
    end
  end

  #same principle of above.
  #create a NEW datastructure
  def append([],y) do y end
  def append([h|t], y) do
    [h|append(t,y)]
  end

  #insert node, assuming it does not exist
  def insert(key, value, :nil) do {:node, key, value, :nil, :nil} end
  def insert(key, value, {:node, k, v, left, right}) do
    if key < k do
      {:node, k, v, insert(key, value, left), right}
    else
      {:node, k, v, left, insert(key, value, right)}
    end
  end

  #delete node, assuming it does exist
  def delete(key, {:node, key, _, :nil, :nil}) do :nil end
  def delete(key, {:node, key, _, :nil, right}) do right end
  def delete(key, {:node, key, _, left, :nil}) do left end

  def delete(key, {:node, key, _, {:node, left_k, _, l1, r2}, {:node,right_k, l1, r2}}) do
    {:node, left_k,_,l1,r2}
  end


  end #FEL, hur ska denna kunna åtgärdas (atm ger den oss en nod utan key pair values)

  def delete(key, {:node, k, v, left, right}) do
    if key < k do
      {:node, k, v, delete(key, left), right}
    else
      {:node, k, v, left, delete(key, right)}
    end
  end

end
