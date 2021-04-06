#Fråga 2.3

defmodule Min do
  @type tree() :: :nil | {:node, integer(), tree(), tree()}

  #hittar minsta värdet i träden
  def mini(:nil) do :inf end
  def mini({:node, val, l , r}) do
    l_val = mini(l)
    r_val = mini(r)

    #choose smallest between left and right
    sub_val = get_min(l_val, r_val)
    #compare smallest subvalues to current node value, choose the smallest
    smallest = get_min(sub_val, val)
  end

  def get_min(x, y) do
    if x < y do
      x
    else
      y
    end
  end

  def test() do
    tree = {:node, 7,
              {:node, 4,
                {:node, 8, :nil, :nil},
                {:node, 5, :nil, :nil}},
              {:node, 2,
                {:node, 6, :nil, :nil},
                {:node, 3, :nil, :nil}}
           }
    mini(tree)
  end
end
