defmodule Derive do

  #doc for own use
  @type literal() :: {:num, number()} | {:var, atom()}
  @type expr() :: literal()
  | {:add, expr(), expr()}
  | {:mul, expr(), expr()}
  | {:exp, expr(), literal()}


  #testfunktion f(x) = 2x + 4
  # f'(x) = 2
  def test1() do
    e = {:add,
          {:mul, {:num, 2}, {:var, :x}},
          {:num, 4}}
    d = derive(e, :x) #derivera testfunktion
    c = calc(d, :x, 5)      #stoppa in x = 5 i derivatan
    IO.write("expression: #{pprint(e)}\n")
    IO.write("derivate: #{pprint(d)}\n")
    IO.write("simplified: #{pprint(simplify(d))}\n")
    IO.write("calculated: #{pprint(simplify(c))}\n")
  end

  #testfunktion f(x) = x^3 + 4
  # f'(x) = 3x^2
  def test2() do
    e = {:add,
          {:exp, {:var, :x}, {:num, 3}},
          {:num, 4}}
    d = derive(e, :x) #derivera testfunktion
    c = calc(d, :x, 4)
    IO.write("expression: #{pprint(e)}\n")
    IO.write("derivate: #{pprint(d)}\n")
    IO.write("simplified: #{pprint(simplify(d))}\n")
    IO.write("calculated: #{pprint(simplify(c))}\n")
  end

  #-----------------derivera följande uttryck m.a.p andra arg; according to rules---------------
  #derive constants/single variables
  def derive({:num, _}, _) do {:num, 0} end
  def derive({:var, v}, v) do {:num, 1} end
  #vi kommer inte ner hit ommönstermatchning ovanför lyckas
  #"catch all", dvs om vi dervierar över en helt anna variabel
  def derive({:var, _}, _) do {:num ,0} end


  #derive addition
  def derive({:add, e1, e2}, v) do
    {:add, derive(e1, v), derive(e2,v)}   #regel '(f + g) = f’ + g’
  end

  #derive multiplication
  def derive({:mul, e1, e2}, v) do
    {:add,
      {:mul, derive(e1,v), e2},
      {:mul, e1, derive(e2, v)}}
  end

  #derive exponent (incl. chain rule), potens = nr (fuskar lite)
  # f(g(x))^n där e kan vara en sammansatt funktion
  # derivatan -> f' * g'
  def derive({:exp, e, {:num, n}}, v) do
    {:mul,
      {:mul, {:num, n}, {:exp, e, {:num, n-1}}},   #f'
      derive(e, v)}                                  #g'
  end

  #---------------------calculator----------------
  def calc({:var, v}, v, val) do {:num, val} end
  def calc({:num, n}, _, _) do {:num, n} end
  def calc({:var, v}, _,_) do {:var, v} end
  def calc({:add, e1, e2}, v, val) do
    {:add, calc(e1, v, val), calc(e2, v, val)}
  end
  def calc({:mul, e1, e2},v ,val) do
    {:mul, calc(e1, v, val), calc(e2, v, val)}
  end
  def calc({:exp, e1, p}, v, val) do
    {:exp, calc(e1, v, val), calc(p, v, val)}
  end

  #simply, förenkla uttrycken
  def simplify({:add, e1, e2}) do
    simplify_add(simplify(e1), simplify(e2))
  end
  def simplify({:mul, e1, e2}) do
    simplify_mul(simplify(e1), simplify(e2))
  end
  def simplify({:exp, e1, e2}) do
    simplify_exp(simplify(e1), simplify(e2))
  end
  def simplify(e) do e end  #"catch all

  def simplify_add({:num, 0}, e2) do e2 end
  def simplify_add(e1,{:num, 0}) do e1 end
  def simplify_add({:num, n1},{:num, n2}) do {:num, n1+n2} end
  def simplify_add(e1, e2) do {:add, e1, e2} end
  #tillägg av flera fall blr jobbigt och redundant. Går det skriva på bättre sätt?

  def simplify_mul({:num, 0}, _) do {:num, 0} end
  def simplify_mul(_, {:num, 0}) do {:num, 0} end
  def simplify_mul(e1, {:num, 1}) do e1 end
  def simplify_mul({:num, 1}, e2) do e2 end
  def simplify_mul({:num, n1}, {:num, n2}) do {:num, n1*n2} end
  def simplify_mul(e1, e2) do {:mul, e1, e2} end      #catch all

  def simplify_exp({:num, 0}, _) do {:num, 1} end
  def simplify_exp( _, {:num, 0}) do {:num, 1} end
  def simplify_exp({:num, 1}, e2) do e2 end
  def simplify_exp(e1, {:num, 1}) do e1 end
  def simplify_exp({:num, x}, {:num, y}) do {:num, :math.pow(x,y)} end
  def simplify_exp(e1, e2) do {:exp, e1, e2} end

  #pretty printing, reutrnerar en snyggare sträng
  def pprint({:num, n}) do "#{n}" end
  def pprint({:var, v}) do "#{v}" end
  def pprint({:add, e1, e2}) do "(#{pprint(e1)} + #{pprint(e2)})"  end
  def pprint({:mul, e1, e2}) do "#{pprint(e1)} * #{pprint(e2)}" end
  def pprint({:exp, e1, e2}) do "(#{pprint(e1)}) ^ (#{pprint(e2)})" end


end
