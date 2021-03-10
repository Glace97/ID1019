# Fråga 9: Denna kod utför ett arbete sekventiellt. Parallellisera
"""
defmodule Proc do
  def start(user) do
    {:ok, spawn(fn() -> proc(user) end)}
  end

  def proc(user) do
    receive do
     {:process, task} ->
        done = doit(task)
        send(user, done)
        proc(user)
      :quit ->
        :ok
    end
  end
end
"""

# parallalliserad variant
defmodule Proc do

  #1. starta process för att göra alla tasks för user
  def start(to_user) do
    #processen väntar på resultat från doit, och kommer mönstermatcha till rätt ordning
    to_collector = spawn(fn() -> collect(to_user, 0) end)
    #anropa funktionen doit skall utföras i
    {:ok, spawn(fn() -> proc(to_collector, 0) end)}
  end

  def proc(to_collector, n) do
    #väntar på task
    receive do
      #om vi får en task, skapa en process omedelbart
      {:process, task} ->
        spawn(fn() ->
          res = doit(task)
          #skicka med ett "sekvensnr"
          send(to_collector, {:done, res, n})
        end)
        proc(to_collector, n+1) #vänta på nästa meddelande att processa
      :quit ->
        send(to_collector, :quit)
      end
  end

  #väntar på resultat från processerad task
  def collect(to_user, n) do
    receive do
      #vi väntar på meddelande #n, allt annat får vänta i kön
      {:done, res, ^n} ->
          send(to_user, res)
          collect(to_user, n+1) #vänta på nästa meddelande
      :quit ->
        :ok
      end
  end
end
