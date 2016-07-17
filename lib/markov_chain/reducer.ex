defmodule MarkovChain.Reducer do
  @moduledoc """
  Specification for a reducer.
  """

  @type t :: __MODULE__
  
  @doc """
  Reduces a list of terms to a single term starting with the given accumulator.
  """
  @callback reduce(list :: [term], acc :: term) :: term
end
