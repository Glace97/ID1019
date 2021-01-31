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
 #   tree = construct_tree(sample)
 #   encode = encode_table(tree)
 #   decode = decode_table(tree)
#  text = text()
 #   seq = encode(text, encode)  #represented as list of 1 and 0s.
  #  decode(seq, decode)
  end

   #read one char at a time, store char and #occurences in frequency list
  def freq(sample) do freq(sample, []) end
  def freq([], freq) do freq end
  def freq([char | rest], freq) do
    if member_freq(char, freq) do
      updated_freq = incr_freq(char, freq, [])
      freq(rest, updated_freq)
    else
      freq(rest, [{char, 1}|freq])
    end
  end



  #build tree, by sending a sorted frequency list
  def construct_tree(sample) do
    freq = (freq(sample))
    sorted_freq = Enum.sort(freq,fn({_,f1}, {_,f2}) -> f1 <= f2 end)  #sort by frequency in ascending order
    huffman(sorted_freq)
  end

  #build and return the huffman tree
  def huffman([{tree, _}]) do tree end
  def huffman([{a, freq_a}, {b, freq_b} | rest]) do
    new_list = [{{a , b}, freq_a + freq_b}] ++ rest   #combine leafs into parent node, append parentnode to sequencelist
    sorted = Enum.sort(new_list, fn({_,f1}, {_,f2}) -> f1 <= f2 end)  #sort sequency list by frequency (rearrange parentnode)
    huffman(sorted)
  end
  #< eller = ?? verkar ge heeeelt olika träd

  #use huffman tree to encode each char
  def encode_table(tree) do encode_table(tree, []) end
  def encode_table({left,right}, encoding) do
    left_result = encode_table(left, [0|encoding])
    right_result = encode_table(right, [1|encoding])
    left_result ++ right_result
  end
  def encode_table(char, encoding) do
    encoding = reverse(encoding)
    encoded_char = {char, encoding}
    [encoded_char]
  end

  def reverse(lst) do reverse(lst,[]) end
  def reverse([], rev) do rev end
  def reverse([h|t], rev) do
    reverse(t, [h|rev])
  end

  #translate plain text info huffman encoding
  def encode(text, table) do encode(text, table, []) end
  def encode([], table, result) do result end
  def encode([c|rest], table, result) do
    result =  [ look_up(c, table) | encode(rest, table, result)]
  end

  #look up matching encoding for given char
  def look_up(c, [{a,encoding}|rest]) do
    cond do
      c === a -> encoding
      true -> look_up(c,rest)
    end
  end
  def look_up(c, []) do
    [:nil]
  end

  def decode(seq, tree) do
    # To implement...
  end

  def decode_table(tree) do
    # To implement...
  end

  #-------------helper functions-------------
  #check if given char already is member in frequency table
  def member_freq(char, []) do false end
  def member_freq(char, [{char,_}|_]) do true end
  def member_freq(char, [{c,_}|t]) do
    member_freq(char, t)
  end

  #reconstructs list and increments frequency for given char (that is member of list)
  def incr_freq(_,[],updated) do updated end
  def incr_freq(char, [{char,freq} | rest], updated) do
   freq = freq + 1
   updated = [{char, freq} | incr_freq(char, rest, updated)]
  end
  def incr_freq(char, [h | rest], updated) do
    updated = [h | incr_freq(char, rest, updated)]
  end



end
