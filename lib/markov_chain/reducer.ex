defmodule MarkovChain.Reducer do
  @doc """
  Reduces a list of terms to a single term starting with the given accumulator.
  """
  @callback reduce(list :: [term], acc :: term) :: term
end
