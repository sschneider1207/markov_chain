defmodule MarkovChain.Reducer.FrequencyReducer do
  @moduledoc """
  Reduces a list of frequency maps to a single frequency map.
  """
  @behaviour MarkovChain.Reducer

  def reduce(maps, acc) do
    do_frequency_reduce(maps, acc)
  end

  def do_frequency_reduce([], acc) do
    acc
  end
  def do_frequency_reduce([h|t], acc) do
    acc = Enum.reduce(h, acc, fn {word, list}, acc -> Map.update(acc, word, list, &(list ++ &1)) end)
    do_frequency_reduce(t, acc)
  end
end
