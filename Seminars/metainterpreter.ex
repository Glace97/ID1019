
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
  def remove(id, env) do remove(id, env, []) end
  def remove([h|rest], [{id,str}| env], new_env) do
    if h == id do
      updated = env ++ new_env
    updated
      #remove(rest, updated, [])
    else
      remove([h|rest], env, [{id, str}|new_env])
    end
  end
  #done checking all ids
  def remove([], updated ,_) do updated end

  #if does not exist in envoriment (catch all)
  def remove(_,[],_) do
    :does_not_exist
  end
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
    nil -> :error
    {_, str} -> {:ok, str}
    end
  end

  #evaluate compound
  def eval_expr({:cons, e1, e2}, env) do
   case eval_expr(e1, env) do
    :error -> :error
    {:ok, str1} ->
    case eval_expr(e2, env) do
     :error -> :error
     {:ok, str2} -> {:ok, {str1, str2}}
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
      nil -> {:ok, Env.add(id, str, env)}
      {_, ^str} -> {:ok, env}
      {_, _} -> :fail
    end
  end

  def eval_match({:cons, hp, tp}, {s1, s2}, env) do
    case eval_match(hp, s1, env) do
      :fail -> :fail
      {:ok,_} -> eval_match(tp, s2, env)
    end
  end

  #catch all, if no match, then fail
  def eval_match(_, _, _) do
    :fail
  end


end
