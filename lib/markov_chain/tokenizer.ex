defmodule MarkovChain.Tokenizer do
  @doc """
  Splits a line into tokens.
  """
  @callback tokenize(line :: String.t) :: [String.t]
end
