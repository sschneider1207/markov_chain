defmodule MarkovChain.Reducer do
  @moduledoc """
  Specification for a reducer.
  """

  @type t :: __MODULE__

  @doc """
  Provides the initial state for a reducer.
  """
  @callback init() :: term

  @doc """
  Reduces a list of terms to a single term starting with the given accumulator.
  """
  @callback reduce(list :: [term], acc :: term) :: term

  @doc """
  Finalize the ouput for the reducer (optional).  
  """
  @callback finalize(acc :: term) :: term

  @optional_callbacks finalize: 1
end
