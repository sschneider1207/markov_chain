defmodule MarkovChain.Analyzer.FrequencyAnalyzerTest do
  use ExUnit.Case
  alias MarkovChain.Analyzer.FrequencyAnalyzer

  test "no tokens returns empty map" do
    assert FrequencyAnalyzer.analyze([]) == %{}
  end

  test "all tokens included in map" do
    assert FrequencyAnalyzer.analyze(["a", "b", "c"]) == %{
      :start => %{"a" => 1},
      "a" => %{"b" => 1},
      "b" => %{"c" => 1},
      "c" => %{:end => 1},
    }
  end

  test "multiple words following a common word are both present in map" do
    assert FrequencyAnalyzer.analyze(["a", "b", "a", "c"]) == %{
      :start => %{"a" => 1},
      "a" => %{"b" => 1, "c" => 1},
      "b" => %{"a" => 1},
      "c" => %{:end => 1},
    }
  end

  test "multiple word combinations have increased frequency" do
    assert FrequencyAnalyzer.analyze(["a", "b", "a", "b", "c"]) == %{
      :start => %{"a" => 1},
      "a" => %{"b" => 2},
      "b" => %{"a" => 1, "c" => 1},
      "c" => %{:end => 1},
    }
  end
end
