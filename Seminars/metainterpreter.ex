
#Module defines environment. [{:x, :foo},{:y, :bar}..] where each atom is unique
defmodule Env do

  #return empty environment
  def new() do [] end

  #return env with binding of id to structure str added
  def add(id, str, env) do
    env = [{id, str} | env]
  end

  #return if {id, str} if bound in env, else return nil
  def lookup(id, []) do :nil end
  def lookup(id, [{h,str}|env]) do
    if h == id do
      {h,str}
    else
      lookup(id, env)
    end
  end

  #return envoriment where ids are removed
  #1st arg: list of ids
  def remove(id,[] ) do [] end
  def remove(id, env) do
    remove(id, env, [])
  end

  def remove([id|rest],[{id,str}|env], new_env) do
      new_env = [env|new_env]
      remove(rest, new_env, [])
  end

  def remove([id|rest],[{h,str} | env], new_env) do
      remove([id|rest], env, [{h,str}|new_env])
  end

  def remove(id, [], new_env) do new_env end

  def remove([], updated,_) do updated end

  def remove([], updated ,_) do updated end


  #creates a new environment from list of variable identifiers and an existing environment
  #add all vars that is bound in enviroment
  def closure(vars, env) do closure(vars, env, [])  end
  def closure([], _, closure) do closure end
  def closure([h|t], env, closure) do
    case lookup(h, env) do
      :nil ->
        :error
      {id, str} ->
        closure(t, env, add(id, str, closure))  #if var bound in env, add to closure
    end

  end

  #returns environment after adding bindings for all vars in sequence of closure
  #par is list of variable id (paramters), strs list of data strucutre,
  #and env (that includes all free variables)
  def args([], [], env) do env end
  def args([h|t], [str|rest], env) do
    args(t, rest, add(h, str, env))
  end
  def args([],_, env) do :error end
  def args(_, [], env) do :error end

end


defmodule Eager do
#---------------------------Evaluation expression ----------------------
  #atom is always true
  def eval_expr({:atm, id}, _, _) do
    IO.write("check atom\n")
    {:ok, id}
  end
  #if variabel id is in env, return str, else bottom (error)
  def eval_expr({:var, id}, env, prg) do
    result = Env.lookup(id, env)
    case result do
      nil ->
        :error
      {_, str} ->
        {:ok, str}
    end
  end

  #evaluate compound/tuple
  def eval_expr({:cons, e1, e2}, env, prg) do
    IO.write("check cons\n")
    case eval_expr(e1, env, prg) do
    :error ->
      :error
    {:ok, str1} ->
      case eval_expr(e2, env, prg) do
        :error ->
          :error
       {:ok, str2} ->
          {:ok, [str1|str2]}  #förändring från {s1,s2}
    end
  end
end

#handles called (named) functions
def eval_expr({:call, id, args}, env, prg) when is_atom(id) do
  #return key in matching tuple (id in prg), where key is in first slot of tuple
  IO.write("kommer vi hit?\n")
  case List.keyfind(prg, id, 0) do
    nil ->
      :error
    {_, par, seq} ->
      case eval_args(args, env, prg) do
        :error ->
          :error
        strs ->
          IO.inspect(strs)
          IO.inspect(par)
          IO.write("env before: ")
          IO.inspect(env)
          env = Env.args(par, strs, env) #ÄNDRAT från env till tom list
          IO.write("\n env, after:")
          IO.inspect(env)
          IO.write("send seg, env, prg:")
          eval_seq(seq, env, prg)

      end
  end
end

#evaluate lambda expression, {λ, paramter, free variables, returned sequence}
#return closure with pattern, free variables and list of bound variables within original env
def eval_expr({:lambda, par, free, seq}, env, _) do

   case Env.closure(free, env) do
    :error ->
      :error
    closure ->
      #returns closure (new enviroment contains values of free variables withing function)
      {:ok, {:closure, par, seq, closure}}
  end
end


#apply arguments to a functiion
def eval_expr({:apply, expr, args}, env, prg) do
  #should evaluate f() that has been previously matched and hopefully, returned a closure-environment
  case eval_expr(expr, env, prg) do
    :error ->
      :error
    {:ok, {:closure, par, seq, closure}} ->
      #will return list of all structures that arguments map to
      case eval_args(args, env, prg) do  #ÄNDRAT FRÅN ENV TILL CLOSURE
         :error ->
           :foo
         strs ->
          #new environment adds all paramterers bound to arguments (structures) to closure-env
          #IO.inspect(strs)
          env = Env.args(par, strs, closure)
          eval_seq(seq, env, prg)
      end
  end
end


#evaluate case expressions
def eval_expr({:case, expr, cls}, env, prg) do
  case eval_expr(expr, env, prg) do
   :error ->
      :error
   {:ok, str} ->
      eval_cls(cls, str, env, prg)
  end
end



#---------------------------Evaluation clause ----------------------
#eval_cls takes a list of clauses, a data structure and env
#selects righ clause and continues execution
def eval_cls([], _, _, _) do
  :error
end

def eval_cls([{:clause, ptr, seq} | cls], str, env, prg) do
  #evaluate new scope, by removing all bindings in env
  vars = extract_vars(ptr)
  new_env = Env.remove(vars, env)

  case eval_match(ptr, str, new_env) do
    #if fails, check next clause
    :fail ->
      eval_cls(cls, str, env, prg)
    #else, evaluatesequence in this (returned) env
    {:ok, env} ->
      eval_seq(seq, env, prg)
  end
end
#---------------------------Evaluation arguments ----------------------
#evaluate arguments, passed as a list of expr; evaulate each expression against env
def eval_args([],_,_) do [] end
def eval_args([arg|rest], env, prg) do
  case eval_expr(arg, env, prg) do
    :error ->
      :error
      #if succeed, evaluate str t
    {_, s} ->
      #if succed, check rest of list, store each evaluated structure in list
      case eval_args(rest, env, prg) do
        :error ->
          :error
        str -> [s|str]
      end
  end
end

#---------------------------Evaluation patternmatching ----------------------
  #dont care always matches, returns unchanged environment
  def eval_match(:ignore, _, env) do
    {:ok, env}
  end

  #if atom maps to str, return same enviroment
  #what happens if does not match?
  def eval_match({:atm, id}, id, env) do
    {:ok, env}
  end

  #matching of variable
  def eval_match({:var, id}, str, env) do
    case Env.lookup(id, env) do
      nil ->
        new_env = Env.add(id, str, env)
        {:ok, new_env}
      {_, ^str} ->
        {:ok, env}
      {_, _} ->
        :fail
    end
  end


  def eval_match({:cons, e1, e2}, [s1|s2] , env) do
    case eval_match(e1, s1, env) do
      :fail ->
        :fail
      {:ok, new_env} ->
       # new_env = Env.add(e1, s1, env)  #added, forgot to add binding when match
        eval_match(e2, s2, new_env)
    end
  end

  #catch all, if no match, then fail
  def eval_match(_, _, _) do
    :fail
  end

  #---------------------------Evaluation sequences ----------------------
  #match-> <pattern> '=' <expr>
  #first arg, patternmatching expression in array
  #last arg: regular expr

  def eval(seq, prg) do
    eval_seq(seq, [], prg)
  end

  def eval_seq([exp], env, prg) do
    eval_expr(exp, env, prg)
  end


  def eval_seq([{:match, id, str}| rst_seq], env, prg) do
    IO.write("now at eval seq , match\n")
    case eval_expr(str, env, prg) do
      #evaluation failed
      :error -> :error
      #evaluation succeeded and datastrc return, pattern = str
      {:ok, str} ->
      #remove all bindings of variables in patter
        vars = extract_vars(id)
        env = Env.remove(vars, env)  #remove all bindings of variable

        #case will assign vairable to str if ok
        case eval_match(id, str, env) do
          :fail ->
            :error
          {:ok, new_env} ->
            eval_seq(rst_seq, new_env, prg)
       end
    end
  end

  #returns a list of all variables in pattern
  def extract_vars(pattern) do extract_vars(pattern, []) end
  def extract_vars(pattern, vars) do
    case pattern do
      {:var, id} -> [id|vars]
      {:cons, p1, p2} -> extract_vars(p1, vars) ++ extract_vars(p2, vars)  #DUBBELKOLLA DENNA RAD
      _ -> vars
    end
  end

end
