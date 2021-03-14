#given a sequenc and generator = [1,0,1,1]
# 1. add 000 to end of sequence
# 2. do XOR with 4 first bits of sequency -> res
# 3. shift one step through sequence and XOR with res -> new res
# 4. repeat process until we are are using one of the thre last bits: in this case; do not shift -> keep the zero

defmodule Crc do

  def test() do
    seq = [1,1,0,1,0,1,0,1,1,1,0,1,0,0,1,0,0]
    compute(seq)
  end

  def compute(seq) do
    appended = seq ++ [0,0,0]
    generator = [1,0,1,1]
    compute(appended, generator)
  end


  #in this case, generator overlaps with three bits
  def compute(seq, generator) do
  #  IO.puts("lst")
    lst = xor(seq, generator)
   # IO.inspect(lst)
    new_seq = jump(lst)
   # IO.puts("new seq")
   # IO.inspect(new_seq)
    if length(generator) <= length(new_seq) do
      compute(new_seq, generator)
    else
      crc = new_seq
    end
  end

  #if a 0; skip through until we reach 1
  def jump([1|t]) do [1|t] end
  def jump([0|t]) do
     jump(t)
  end

  #takes two lists and XOR first bits
  def xor([], b) do b end
  def xor(a, []) do a end
  def xor([1|a], [1|b]) do
    [0 | xor(a, b)]
  end
  def xor([0|a],  [0|b]) do
    [0 | xor(a, b)]
  end
  def xor([_|a], [_|b]) do
    [1 | xor(a,b)]
  end
end
