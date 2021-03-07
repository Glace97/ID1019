
defmodule Index do
 def index(runs) do index(runs, 0) end

 def index([a|b], h) do
  if h < a do
    index(b, h + 1)
  else
    h
  end
 end

 def index([], h) do
  h
 end

end
