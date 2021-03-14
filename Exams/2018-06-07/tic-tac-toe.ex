#mest för att experiment hur meddelanden läggs i kö

defmodule Tic do


  def first(mother_process) do
    receive do
      :tic ->
        second(mother_process, [:tic])
      :tac ->
        second(mother_process, [:tac])
      end
  end

  def second(mother_process,all) do
    receive do
      :tic ->
        third(mother_process, [:tic|all])
      :toe ->
        third(mother_process, [:toe|all])
    end
  end

  def third(mother_process, all) do
    receive do
      x ->
        send(mother_process, {:ok, [x|all]})
    end
  end


  def test() do
    self = self()
    program = spawn(fn()-> first(self) end)
    send(program, :tic)
    send(program, :first_sent) #kommer inte mönstermatcha förrens i third -> hamnar i FIFO kö
    send(program, :second_sent) #kommer alltid sitta i kö
    send(program, :third_sent)  #kommer alltid sitta i kö
    send(program, :toe)

    receive do
      {:ok, res} ->
        res
    end
  end

end
