defmodule MarkovChain.Analyzer do
  @moduledoc """
  Specification for a token analyzer.
  """

  @type t :: __MODULE__
  
  @doc """
  Analyzes a list of tokens.
  """
  @callback analyze(tokens :: [String.t]) :: term
end
