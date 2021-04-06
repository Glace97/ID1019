#Given a sentance, count nr of frequencies for each character and return.
#Implement paralell execution.

defmodule Parfreq do

  def start(str) do
    #get all unique elements in string
    letters = Enum.uniq(str)
    #tar en lista, och en funktion som skall utföras på varje element i listan
    refs = Enum.map(letters, frequency(str)) #returnera en referens till varje element i listan (omedelbart)
    freq = Enum.map(refs, collection())
    map_answer(letters, freq)
  end

  def map_answer([], []) do [] end
  def map_answer([letter|t], [freq|rest]) do
    [{letter, freq} | map_answer(t, rest)]
  end

  def frequency(str) do
    me = self()

    #för denna unika bokstav i listan
    fn(x) ->
      ref = make_ref() #unique refrence for this particular element
      spawn(fn() ->
        #kommer vara elementet i listan med unika bokstäver
        res = count_frequency(x, str, 0)
        #send result when done
        send(me, {:done, res, ref})
      end)
    ref
    end
  end

  #collection kör på main process och väntar på svar
  def collection() do
    fn(ref) ->
      receive do
      #this ref == den referensen vi läser av i listan
        {:done, res, ^ref} ->
          res
      end
    end
  end

  def count_frequency(_, [], res) do res end
  def count_frequency(x, [x|t], acc) do
    count_frequency(x, t, acc+1)
  end
  def count_frequency(x, [h|t], acc) do
    count_frequency(x, t, acc)
  end

  #måste retuerna en funktion som utförst på ETT element
  def frequency()


  def test() do
    str = 'hejsvejhej'
    start(str)
  end

end
