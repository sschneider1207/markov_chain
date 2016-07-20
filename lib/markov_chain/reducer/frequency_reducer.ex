defmodule MarkovChain.Reducer.FrequencyReducer do
  @moduledoc """
  Reduces a list of frequency maps to a single frequency map.
  """
  @behaviour MarkovChain.Reducer
  alias MarkovChain.Analyzer.FrequencyAnalyzer

  def init do
    :ets.new(:freq_reducer, [:private])
  end

  def reduce(maps, tab) do
    do_frequency_reduce(maps, tab)
  end

  defp do_frequency_reduce([], tab) do
    tab
  end
  defp do_frequency_reduce([h|t], tab) do
    Enum.each(h, &update_frequencies(tab, &1))
    do_frequency_reduce(t, tab)
  end

  defp update_frequencies(tab, {key, counts}) do
    Enum.each(counts, &update_count(tab, key, &1))
  end

  defp update_count(tab, key, {word, count}) do
    :ets.update_counter(tab, {key, word}, count, {[], 0})
  end

  def finalize(tab) do
    freq_map = tab_to_freq_map(tab)
    :ets.delete(tab)
    freq_map
  end

  defdelegate tab_to_freq_map(tab), to: FrequencyAnalyzer
end
