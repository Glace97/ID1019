defmodule Redo do


  #fråga 2, skapa stack och föreslå en datortyp
  @type stack() :: [any()]

  def new_stack() do
    []
  end

  def push(el, stack) do
    [el|stack]
  end

  def pop([]) do :no end
  def pop([top|rest]) do
    {:ok, top, rest}
  end


  #fråga 3, implementera flatten; returnera vanlig platt lista
  #given lista kan vara listor av listor OSV tidskomplexiotet oviktigt

  def flatten([]) do [] end
  def flatten([ [h | rest] | t]) do
    #flatten resten av listan om head faktiskt är en lista -> förutsatt vi vill ha en helt platt lista oavsett
    flatten([h]) ++ flatten(rest) ++ flatten(t)
  end
  def flatten([el | t]) do
    [el] ++ flatten(t)
  end

  #fråga 4; h-värde. h är värdet av sträckor som är minst h-lång sprunget minst h ggr.
  # index/1 tar en ordnat lista (med sträckor i descending order) och returnerar h, startvärde h = 0

  def index(lst) do index(lst, 0) end
  def index([s |rest], runs) do
    if(s <= runs) do
      h = runs
    else
      index(rest, runs + 1)
  end
  end


  # fråga 5, kompaktare; implementera compact/1
  # tar ett träd vars löv innehåller en value
  # FALL 1 = en nod med två likadan löv => ersätt till ett sådant löv
  # FALL 2 = en nod med ensam löv 0 > ersätt till ett sådant löv
  @type tree() :: :nil | {:node, tree(), tree()} | {:leaf, any()}

  #traversera ner längst trädet. Vad vill vi se när vi når följande?
  def compact(:nil) do :nil end
  def compact({:leaf, value}) do {:leaf, value} end
  #vi har nått en nod med två likadan leaves (fall 1)
  def compact({:node, {:leaf, value}, {:leaf, value}}) do
    {:leaf, value} #ersätt noden med ett enda löv
  end
  # vi har nått en nod med ett ensamt löv (fall 2)
  def compact({:node, {:leaf, value}, :nil}) do
    {:leaf, value}
  end
  def compact({:node, :nil, {:leaf, value}}) do
    {:leaf, value}
  end

  #forsätt traversera ner om vi befinner oss mitt i trädet annars
  def compact({:node, left, right}) do
    l_tree = compact(left)
    r_tree = compact(right)

    #kombinera träden som vi ersatt nya formatet med
    combine(l_tree, r_tree)
  end

  #kombinera träd
  def combine(:nil, :nil) do
    :nil
  end
  def combine(:nil, {:leaf, value}) do {:leaf, value} end
  def combine({:leaf, value} , :nil) do {:leaf, value} end
  def combine(l, r) do
    {:node, l, r}
  end

  #fråga 7 nästa primtal   ** spara denna, fråga någon annan **

  #fråga 8: en bättre flatten (linjär tidskomplexitet) dvs ingen ++

  #fråga 9: skapa en parallell map
  def pmap(lst, fun) do
    refrences = Enum.map(lst, parallel(fun))

    #Collect all refrences
    results = Enum.map(refrences, collect())
  end

  def parallel(fun) do
    me = self() #moderprocess

    #instanstiera en proces och utför operation, returnerar en function som är en referens
    #skapa och skicka iväg process till trådpool, may or may not göras i ordning/ eller paralellt
    fn(x) ->
      ref = make_ref()    #tagga nyskapad process, return unique refrence
      spawn(fn() ->
        res = fun.(x) #operationen gjord på elementet

        #skicka nu, denna process med references och resultet
        send(me, {:ok, ref, res})
      end)

    ref #returnera referensen omedelbart oavsett om processen är färdig
    end
  end

  #VARFÖR är dessa alltid i funktioner= För att enligt maps måste collect() returnera en FUNKTION
  def collect() do
    fn(ref) ->
      receive do
        {:ok, ^ref, res} -> res
      end
    end
  end
end
