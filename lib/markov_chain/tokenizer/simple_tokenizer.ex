defmodule MarkovChain.Tokenizer.SimpleTokenizer do
  @moduledoc """
  Splits a string on whitespace and punctuation.  Also removes quotations.
  """
  @behaviour MarkovChain.Tokenizer
  @punctuation ~C( ,.?!;:-&/)

  def tokenize(line) do
    String.downcase(line)
    |> do_simple_tokenizer([], [])
  end

  defp do_simple_tokenizer(<<?\s, rem :: binary>>, [], tokens) do
    do_simple_tokenizer(rem, [], tokens)
  end
  defp do_simple_tokenizer(<<?\s, rem :: binary>>, acc, tokens) do
    word = Enum.reverse(acc) |> to_string()
    do_simple_tokenizer(rem, [], [word|tokens])
  end
  defp do_simple_tokenizer(<<p :: utf8, rem :: binary>>, [], tokens) when p in @punctuation do
    do_simple_tokenizer(rem, [], [to_string([p])|tokens])
  end
  defp do_simple_tokenizer(<<p :: utf8, rem :: binary>>, acc, tokens) when p in @punctuation do
    word = Enum.reverse(acc) |> to_string()
    do_simple_tokenizer(rem, [], [to_string([p])|[word|tokens]])
  end
  defp do_simple_tokenizer(<<?" :: utf8, rem :: binary>>, [], tokens) do
    do_simple_tokenizer(rem, [], tokens)
  end
  defp do_simple_tokenizer(<<?" :: utf8, rem :: binary>>, acc, tokens) do
    word = Enum.reverse(acc) |> to_string()
    do_simple_tokenizer(rem, [], [word|tokens])
  end
  defp do_simple_tokenizer(<<c :: utf8, rem :: binary>>, acc, tokens) do
    do_simple_tokenizer(rem, [c|acc], tokens)
  end
  defp do_simple_tokenizer(<<>>, [], tokens) do
    Enum.reverse(tokens)
  end
  defp do_simple_tokenizer(<<>>, acc, tokens) do
    word = Enum.reverse(acc) |> to_string()
    Enum.reverse([word|tokens])
  end
end
