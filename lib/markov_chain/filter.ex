defmodule MarkovChain.Filter do
  @moduledoc """
  Specification for a token filter.
  """

  @type t :: __MODULE__

  @doc """
  Filters a list a tokens.
  """
  @callback filter(tokens :: [String.t]) :: [String.t]
end
