
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

 # def remove([h|rest], [{id,str}| env], new_env) do
 #   if h == id do
 #       updated = env ++ new_env
 #     remove(rest, updated, [])
 #   else
 #     remove([h|rest], env, [{id, str}|new_env])
 #   end
 # end
  #done checking all ids
  def remove([], updated ,_) do updated end

  #if does not exist in envoriment (catch all)
  #def remove(_,[],_) do
  #  :does_not_exist
  #end
end

#existst for reasons that will be given later
defmodule Eager do

  #evaluation
  #atom is always true
  def eval_expr({:atm, id}, _) do {:ok, id} end
  #if variabel id is in env, return str, else bottom (error)
  def eval_expr({:var, id}, env) do
    result = Env.lookup(id, env)
    case result do
      nil ->
        :error
      {_, str} ->
        {:ok, str}
    end
  end

  #evaluate compound
  def eval_expr({:cons, e1, e2}, env) do
    case eval_expr(e1, env) do
    :error ->
      :error
    {:ok, str1} ->
      case eval_expr(e2, env) do
        :error ->
          :error
       {:ok, str2} ->
          {:ok, [str1 | str2 ]}  #förändring från {s1,s2}
    end
  end
end

  #patternmatchning

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
      {:ok,_} ->
        new_env = Env.add(e1, s1, env)  #added, forgot to add binding when match
        eval_match(e2, s2, new_env)
    end
  end

  #catch all, if no match, then fail
  def eval_match(_, _, _) do
    :fail
  end

  #evaluate sequences
  #match-> <pattern> '=' <expr>
  #first arg, patternmatching expression in array
  #last arg: regular expr

  def eval(seq) do
    eval_seq(seq, [])
  end

  def eval_seq([exp], env) do
    eval_expr(exp, env)
  end


  def eval_seq([{:match, id, str} = pattern | rst_seq], env) do
    case eval_expr(str, env) do
      #evaluation failed
      :error -> :error
      #evaluation succeeded and datastrc return, pattern = str
      {:ok, str} ->
      #remove all bindings of variables in patter

      vars = extract_vars(id)
      env = Env.remove(vars, env)  #remove all bindings of variable

        #case will assign vairable to str if ok
         case eval_match(id, str, env) do
          :fail -> :error
          {:ok, new_env} -> 
            eval_seq(rst_seq, new_env)
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
