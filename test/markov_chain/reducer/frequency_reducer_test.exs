defmodule MarkovChain.Reducer.FrequencyReducerTest do
  use ExUnit.Case
  alias MarkovChain.Reducer.FrequencyReducer

  setup do
    tab = FrequencyReducer.init()
    {:ok, tab: tab}
  end

  test "no maps reduce to empty map", %{tab: tab} do
    FrequencyReducer.reduce([], tab)
    assert FrequencyReducer.tab_to_freq_map(tab) == %{}
  end

  test "single map reduces to itself", %{tab: tab} do
    map = %{
      "a" => %{
        "b" => 1,
        "c" => 2
      }
    }
    FrequencyReducer.reduce([map], tab)
    assert FrequencyReducer.tab_to_freq_map(tab) == map
  end

  test "multiple maps reduce correctly", %{tab: tab} do
    maps = %{
      "a" => %{
        "b" => 1,
      },
      "c" => %{
        "d" => 1
      }
    } |> List.duplicate(100)
    FrequencyReducer.reduce(maps, tab)
    assert FrequencyReducer.tab_to_freq_map(tab) == %{
      "a" => %{
        "b" => 100,
      },
      "c" => %{
        "d" => 100
      }
    }
  end
end
