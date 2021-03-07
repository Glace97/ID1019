defmodule Prime do

 #läs mer om på https://hexdocs.pm/elixir/typespecs.html#built-in-types

  @type next() :: {:ok, integer(), ( -> next())}
  #primes, return infinetly nr of primes
  @spec primes() :: ( -> next())


  #return function, start at prime nr 2, next prime number is 3
  def primes() do
    fn() -> {:ok, 2, fn() -> sieve(2, fn() -> next(3) end) end} end
  end

  #first next; {:ok, 3, next(4)}
  def next(n) do
    {:ok, n, fn() -> next(n+1) end}
  end

  def sieve(p, f) do
    {:ok, n, f} = f.()  #anropa next funktionen och returnera denna tupeln
    #om talet n kan delas med primtalet
    if rem(n, p) == 0 do
      sieve(p, f) #gå vidare till nästa, f genererar nästa tal
    else
      #returnera detta tal
      {:ok, n, fn() -> sieve(n, fn() -> sieve(p, f) end) end}
    end
  end

end
