defmodule MarkovChain.Tokenizer do
  @moduledoc """
  Specification for a string tokenizer.
  """

  @type t :: __MODULE__
  
  @doc """
  Splits a line into tokens.
  """
  @callback tokenize(line :: String.t) :: [String.t]
end
