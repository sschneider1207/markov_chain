defmodule FrequencyAnalyzerBench do
  use Benchfella
  alias  MarkovChain.Analyzer.FrequencyAnalyzer

  #bench "analyze 100", data: test_data(100) do
  #  FrequencyAnalyzer.analyze(data)
  #end

  #bench "analyze 10_000", data: test_data(10_000) do
  #  FrequencyAnalyzer.analyze(data)
  #end

  #bench "analyze 1_000_000", data: test_data(1_000_000) do
  #  FrequencyAnalyzer.analyze(data)
  #end

  defp test_data(amount) do
    ?a..?z
    |> Stream.cycle()
    |> Stream.take(amount)
    |> Enum.shuffle()
  end
end
