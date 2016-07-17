defmodule MarkovChain.Analyzer do
  @doc """
  Analyzes a list of tokens.
  """
  @callback analyze(tokens :: [String.t]) :: term
end
