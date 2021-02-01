defmodule Huffman do
####################test##################################
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
    tree = construct_tree(sample)
    encode = encode_table(tree)
    decode = decode_table(tree)
    text = text()
    seq = encode(text, encode)
    decode(seq, decode)
  end

  #####################################################################################
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

 #####################################################################################
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

 #####################################################################################
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

  #generate encoding table for decoding
  def decode_table(tree) do encode_table(tree) end

  def reverse(lst) do reverse(lst,[]) end
  def reverse([], rev) do rev end
  def reverse([h|t], rev) do
    reverse(t, [h|rev])
  end

  #####################################################################################

  #translate plain text info huffman encoding
  #time complexity: encode -> linear for each char in text, + lookup (linear for each recursive call) + append which is linear
  #therefore n*n*n -> O(n^3) (not the greatest)
  def encode(text, table) do encode(text, table, []) end
  def encode([], table, result) do result end
  def encode([c|rest], table, result) do
    result =  look_up(c, table) ++ encode(rest, table, result)
  end

  #look up matching encoding for given char
  #time complexity; worst caste; linear for looking trough all encoded characters
  def look_up(c, [{a,encoding}|rest]) do
    cond do
      c === a -> encoding
      true -> look_up(c,rest)
    end
  end
  def look_up(c, []) do
    [:nil]
  end

  #####################################################################################
  #decode a encoded sequence
  def decode([], _) do [] end
  def decode(seq, table) do
    {char, rest} = decode_char(seq, 1, table) #get one char and rest of sequence
    [char | decode(rest, table)]
  end

  #check sequence for first matching characters
  def decode_char([],_,_) do [] end
  def decode_char(seq, n, table) do
    #Enum.split: splits the enumarable into two lists with first list being n-element large.
    {code, rest} = Enum.split(seq, n)
    #keyfind: match with tuple in table, code will match second slot in tuple
    case List.keyfind(table, code, 1) do
       #return the char and rest of sequence if match
      {char, code} -> {char, rest};
      #if no match, try with 1-bit longer sequence
      nil -> decode_char(seq, n+1, table)
    end
  end

 #####################################################################################
 #performance tests

 #read a chunk of text for benchmarking
 def read(file, n) do
    {:ok, sample} = File.open(file, [:read])
    binary = IO.read(sample, n)
    File.close(sample)
    length = byte_size(binary)  #byte_size function returns number of bytes in binary
    #converting characters to unciode - text expressed in most of worlds writing
    #utf 8, characters stored in 1 byte
    case :unicode.characters_to_list(binary, :utf8) do
    {:incomplete, chars, rest} -> {chars, length - byte_size(rest)}
    chars -> {chars, length}
    end
  end


  #measure time for each operation
  # Anrop Huffman.benchmark("kallocain.txt", n), n från 1000 uppåt
  def benchmark(file, n) do
    {text,_} = read(file, n)  #store read file in tuple
    c = length(text)
    {tree,t1} = timer(fn -> construct_tree(text) end)  #includes time for building frequencylist
    {encode_table,t2} = timer(fn -> encode_table(tree) end)
    size = length(encode_table)
    {decode_table, _} = timer(fn -> decode_table(tree) end)
    {encoding, t3} = timer(fn-> encode(text, encode_table) end)
    {_, t4} = timer(fn -> decode(encoding, decode_table) end)
    encoding_size = div(length(encoding), 8)  # #bytes stores

    IO.puts("text: #{c} characters")
    IO.puts("#{t1}ms building frequency table and huffmantree")
    IO.puts("#{t2}ms building encoding table")
    IO.puts("#{t3}ms encoding given text")
    IO.puts("#{t4}ms decoding text")
    IO.puts("#{t1}ms building frequency table and tree")
    IO.puts(" #{size} nr of characters, #{encoding_size}: size of encoding")
  end

  #measure time taken for each func
  def timer(func) do
    start_time = Time.utc_now()
    result = func.()
    end_time = Time.utc_now()
    {result, Time.diff(end_time, start_time, :microsecond) / 1000}
  en
end
