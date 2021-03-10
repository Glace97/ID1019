# Fråga 8
# Räkna ut kortaste avståndet mellan två städer
# givet en stad ska vi kunna plocka uut en lista över närmasten grannar och avståenden till dessa

defmodule Enkel do
  @type city() :: atom()
  @type dist() :: integer() | :inf  #infinity

  #givet en lista från stad, till stad; och en karta -> returnera avståndet
  @spec shortest(city(), city(), map()) :: dist()

  #startfunktion
  def shortest(from, to, map) do

    #shortest path tree set, keep track of vertices included in shortest path
    #assign distance value as 0: from source node, staden = to mappar avstånd 0
    sptSet = Map.new([{to, 0}])
    {:found, dist, _} = check (from, to, map , sptSet)
    #returns shortest distance
    dist
  end

  #kollar avstånd
  @spec check(city(), city(), map(), map()) :: {:found, dist(), map()}

  def check(from, to, map , sptSet ) do
    #get value (distance) from our startlocation (key), given built map
    case Map.get(sptSet, from) do
      #if no distance found, check shortest path and build map
      nil ->
        shortest(from, to, map , sptSet )
        #if distance value found, return
      distance ->
        {:found, distance, map}
    end
  end


  @spec shortest(city(), city(), map(), map()) :: {:found, dist(), map()}

  def shortest(from, to, map , sptSet ) do
    #set the road distance to infinity
    updated =  Map.put(sptSet , from , :inf)  #map from sourcenode is updated with info
    .... = Map.get(.... , from)   #get distance 
    .... = select(neighbours, to, updated, map)
    ....
    {:found, dist, updated}
  end

  @spec select([{:city, city(), integer()}], city(), map(), map()) :: {:found, dist(), map()}

  def select([], _, .... , .... ) do .... end

  def select([{:city, next, d1} | rest], to, ..... , ..... ) do
    .... = check(next, to, .... , .... )
    dist = add(d1,d2)
    .... = select(rest, to, .... , .... )

    if sele < dist do
      {:found, sele, updated}
    else
      {:found, dist, updated}
    end
  end

  @spec add(dist(), dist()) :: dist()

  def add( .... , .... ) do .... end
  def add( .... , .... ) do .... end
  def add( .... , .... ) do .... end

end
