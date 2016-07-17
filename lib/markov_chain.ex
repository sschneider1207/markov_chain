alias Experimental.GenStage

defmodule MarkovChain do
  alias MarkovChain.{TokenizerStage, AnalyzerStage, ReducerStage}

  def init(input, tokenizer, analyzer, reducer) do
    input
    |> Enum.map(&tokenizer.tokenize/1)
    |> Enum.map(&analyzer.analyze/1)
    |> reducer.reduce(%{})
  end

  def init(input, tokenizer, analyzer, reducer, parallelism, timeout \\ 60_000) do
    {:ok, producer} = GenStage.from_enumerable(input)

    for _ <- 1..parallelism do
      {:ok, tokenizer} = TokenizerStage.start_link(tokenizer)
      {:ok, analyzer} = AnalyzerStage.start_link(analyzer)
      {:ok, reducer} = ReducerStage.start_link(reducer, self)

      GenStage.sync_subscribe(reducer, to: analyzer)
      GenStage.sync_subscribe(analyzer, to: tokenizer)
      GenStage.sync_subscribe(tokenizer, to: producer)
    end
    maps = get_maps(parallelism, [], timeout)
    reducer.reduce(maps, %{})
  end

  defp get_maps(0, acc, _timeout) do
    acc
  end
  defp get_maps(rem, acc, timeout) do
    freq_map = receive do
      {:done, map} -> map
    after
      timeout -> raise "Timeout"
    end
    get_maps(rem - 1, [freq_map|acc], timeout)
  end

  def generate_string(freq_map) do
    :random.seed(:erlang.system_time)
    do_generate_string(freq_map, :start, [])
  end

  defp do_generate_string(_freq_map, :end, acc) do
    Enum.join(acc, " ")
  end
  defp do_generate_string(freq_map, prev_token, acc) do
    list = freq_map[prev_token]
    token = Enum.random(list)
    do_generate_string(freq_map, token, [token|acc])
  end
end
