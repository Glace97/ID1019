# fråga 3: nth leaf
#  nth/2, hiutitar nth lövet i ett binärt träd,
# traversering: djupet först, vänster till höger, n> 0
# returnera {:found, val} om hittat och har värdet val; ELLER {:cont, k} om vi bara hittat n-k löv med vi har k till för att komma till n

defmodule Nth do
  @type tree() :: {:leaf, any()} | {:node, tree(), tree()}

  #we only had one leaf left
  def nth({:leaf, val}, 1) do
    {:found, val}
  end
  def nth({:leaf, val}, n) do
    k = n-1
    {:cont, k}
  end

  def nth({:node, l, r}, n) do
    case nth(l, n) do
      {:cont, k} ->
        case nth(r, k) do
          {:found, val} ->
            {:found, val}
          {:cont, k} ->
            {:cont, k}
        end
      {:found, val} ->
        {:found, val}
      end
  end
  
end
