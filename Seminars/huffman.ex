defmodule Huffman do

  def sample do
    'the quick brown fox jumps over the lazy dog
    this is a sample text that we will use when we build
    up a table we will only handle lower case letters and
    no punctuation symbols the frequency will of course not
    represent english but it is probably not that far off'
  end

  def text()  do
    'this is something that we should encode'
  end

  def test do
    sample = sample()
    tree = tree(sample)
    encode = encode_table(tree)
    decode = decode_table(tree)
    text = text()
    seq = encode(text, encode)  #represented as list of 1 and 0s.
    decode(seq, decode)
  end

  def freq(sample) do
    #run through samplelist ([102,111,111] osv), collect freq of char
    #spara som tuple med char och frek nr?
    freq(sample, [])
  end

  #basecase
  def freq([], freq) do isort(freq) end
  #take char and store within frequency
  def freq([char | rest], freq) do
    if member_freq(char, freq) do
      updated_freq = incr_freq(char, freq, [])
      freq(rest, updated_freq)
    else
      freq(rest, [{char, 1}|freq])
    end
  end



  #spara noder som @type :: {char, frek} | {freq_sum}
  def tree(sample) do
    freq = freq(sample)   #find out frequencies of tble
    #huffman(freq)
  end

  def encode_table(tree) do
    # To implement...
  end

  def decode_table(tree) do
    # To implement...
  end

  def encode(text, table) do
    # To implement...
  end

  def decode(seq, tree) do
    # To implement...
  end

  #-------------helper functions-------------
  def member_freq(char, []) do false end
  def member_freq(char, [{char,_}|_]) do true end
  def member_freq(char, [{c,_}|t]) do
    member_freq(char, t)
  end

  #reconstructs list and increments selected frequence
  def incr_freq(_,[],updated) do updated end
  def incr_freq(char, [{char,freq} | rest], updated) do
   freq = freq + 1
   updated = [{char, freq} | incr_freq(char, rest, updated)]
  end
  def incr_freq(char, [h | rest], updated) do
    updated = [h | incr_freq(char, rest, updated)]
  end

  #sort by frequency, lowest frecuency at lowest index
  def isort(lst) do isort(lst, [])end
  def isort([], sorted) do sorted end
  def isort([h|t], sorted) do
    sorted = insert(h,sorted)
    isort(t, sorted)
  end

  #inserts element in right place, ascending order
  def insert({c,element},[]) do [{c,element}] end
  def insert({c, element}, [{x,freq}|rest]) do
    if (element < freq) do
      [{c, element},{x,freq}| rest]
    else
       [{x, freq}] ++ insert({c, element},rest)
    end
  end

end
