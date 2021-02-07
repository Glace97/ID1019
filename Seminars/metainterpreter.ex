
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
      remove(rest, updated, [])
    else
      remove([h|rest], env, [{id, str}|new_env])
    end
  end

  #if does not exist in envoriment
  def remove(_,[],_) do
    :does_not_exist
  end
  #done checking all ids
  def remove([], updated ,_) do updated end


end
