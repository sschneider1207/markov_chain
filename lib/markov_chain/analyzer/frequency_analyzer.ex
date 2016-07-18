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
    acc = %{:start => %{a => 1}, a => %{b => 1}}
    do_frequency_analysis([b|tail], acc)
  end

  defp do_frequency_analysis([a|[b|tail]], acc) do
    acc = Map.update(acc, a, %{b => 1}, fn freq ->
      Map.update(freq, b, 1, &(&1 + 1))
    end)
    do_frequency_analysis([b|tail], acc)
  end
  defp do_frequency_analysis([a|[]], acc) do
    Map.put(acc, :end, %{a => 1})
  end
end
