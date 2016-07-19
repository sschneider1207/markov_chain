defmodule MarkovChain.Analyzer.FrequencyAnalyzer do
  @moduledoc """
  Analyzes based on the the frequency of tokens that follow a key.
  """
  @behaviour MarkovChain.Analyzer

  def analyze(tokens) do
    do_frequency_analysis(tokens)
  end

  defp do_frequency_analysis([]) do
    %{}
  end
  defp do_frequency_analysis([a|[]]) do
    %{:start => %{a => 1}, a => %{:end => 1}}
  end
  defp do_frequency_analysis([a|[b|tail]]) do
    tab = :ets.new(:freq_map, [:private])
    :ets.update_counter(tab, {:start, a}, 1, {[], 0})
    :ets.update_counter(tab, {a, b}, 1, {[], 0})
    do_frequency_analysis([b|tail], tab)
  end

  defp do_frequency_analysis([a|[b|tail]], tab) do
    :ets.update_counter(tab, {a, b}, 1, {[], 0})
    do_frequency_analysis([b|tail], tab)
  end
  defp do_frequency_analysis([a|[]], tab) do
    :ets.update_counter(tab, {a, :end}, 1, {[], 0})
    freq_map =
      tab
      |> :ets.tab2list()
      |> List.foldl(%{}, fn {{key, val}, count}, map ->
        Map.update(map, key, %{val => count}, &Map.put(&1, val, count))
        end)
    :ets.delete(tab)
    freq_map
  end
end
