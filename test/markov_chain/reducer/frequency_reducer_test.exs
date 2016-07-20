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
      "a" => %{"b" => 1, "c" => 2}
    }
    FrequencyReducer.reduce([map], tab)
    assert FrequencyReducer.tab_to_freq_map(tab) == map
  end

  test "duplicate maps reduce correctly", %{tab: tab} do
    maps = %{
      :start => %{"a" => 1},
      "a" => %{"b" => 1},
      "c" => %{"d" => 1},
      "d" => %{:end => 1}
    } |> List.duplicate(100)
    FrequencyReducer.reduce(maps, tab)
    assert FrequencyReducer.tab_to_freq_map(tab) == %{
      :start => %{"a" => 100},
      "a" => %{"b" => 100},
      "c" => %{"d" => 100},
      "d" => %{:end => 100}
    }
  end

  test "same keys different value maps reduce correctly", %{tab: tab} do
    m1 = %{
      :start => %{"a" => 1, "b" => 2},
      "a" => %{"c" => 3},
      "b" => %{"d" => 4, :end => 5},
      "c" => %{:end => 6},
      "d" => %{:end => 7}
    } |> List.duplicate(100)
    m2 = %{
      :start => %{"z" => 1, "y" => 2},
      "a" => %{"x" => 3},
      "b" => %{"w" => 4, :end => 5},
      "c" => %{:end => 6},
      "d" => %{:end => 7}
    } |> List.duplicate(100)
    FrequencyReducer.reduce(m1 ++ m2, tab)
    assert FrequencyReducer.tab_to_freq_map(tab) == %{
      :start => %{"a" => 100, "b" => 200, "z" => 100, "y" => 200},
      "a" => %{"c" => 300, "x" => 300},
      "b" => %{"d" => 400, "w" => 400, :end => 1000},
      "c" => %{:end => 1200},
      "d" => %{:end => 1400}
    }
  end

  test "different keyed maps reduce correctly", %{tab: tab} do
    m1 = %{
      :start => %{"a" => 1, "b" => 2},
      "a" => %{"c" => 3},
      "b" => %{"d" => 4, :end => 5},
      "c" => %{:end => 6},
      "d" => %{:end => 7}
    } |> List.duplicate(100)
    m2 = %{
      :start => %{"z" => 1, "y" => 2},
      "z" => %{"x" => 3},
      "y" => %{"w" => 4, :end => 5},
      "x" => %{:end => 6},
      "w" => %{:end => 7}
    } |> List.duplicate(100)
    FrequencyReducer.reduce(m1 ++ m2, tab)
    assert FrequencyReducer.tab_to_freq_map(tab) == %{
      :start => %{"a" => 100, "b" => 200, "z" => 100, "y" => 200},
      "a" => %{"c" => 300},
      "b" => %{"d" => 400, :end => 500},
      "c" => %{:end => 600},
      "d" => %{:end => 700},
      "z" => %{"x" => 300},
      "y" => %{"w" => 400, :end => 500},
      "x" => %{:end => 600},
      "w" => %{:end => 700}
    }
  end
end
