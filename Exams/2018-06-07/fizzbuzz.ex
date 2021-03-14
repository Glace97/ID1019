#Fråga 4 (rekursion)
#givet ett tal n -> ge till baka en lista med de första n elementen i fizzbuzz serien
# 1. Alla tal delbara med 3 ersätts med fizz
# 2. Alla tal delbara med 5 ersätts med buzz
# 3. Alla tal delbara med 3 OCH 5 ersätts med fizzbuzz
defmodule Fizzbuzz do
  def fizzbuzz(n) do fizzbuzz(1, n) end

  #arg 1: nästa element i listan
  #arg 2: veta när vi är klara
  #arg 3 och 4: håller koll på om tal är delbart med 3 eller 5
  def fizzbuzz(_, 0) do [] end

  def fizzbuzz(el, n) when rem(el, 3*5)  == 0 do
    [:fizzbuzz | fizzbuzz(el+1, n-1)]
  end
  def fizzbuzz(el, n) when rem(el, 5)  == 0 do
    [:buzz| fizzbuzz(el+1, n-1)]
  end
  def fizzbuzz(el, n) when rem(el, 3)  == 0 do
    [:fizz| fizzbuzz(el+1, n-1)]
  end
  def fizzbuzz(el, n) do
    [el | fizzbuzz(el+1, n-1)]
  end
end
