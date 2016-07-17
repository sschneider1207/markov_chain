Application.ensure_started(:markov_chain)
alias MarkovChain.{TokenizerStage, AnalyzerStage, ReducerStage}
alias Experimental.GenStage

IO.puts "Pulling elastic search data..."
%{hits: hits} = Elasticsearch.query("lirik", "chat_message", "*:*", 0, 50_000)
list = Enum.map(hits, &get_in(&1, ["_source", "text"]))
IO.puts "Found #{length(list)} documents."

{:ok, a} = GenStage.from_enumerable(list)
{:ok, b} = TokenizerStage.start_link(MarkovChain.Tokenizer.SimpleTokenizer)
{:ok, c} = AnalyzerStage.start_link(MarkovChain.Analyzer.FrequencyAnalyzer)
{:ok, d} = ReducerStage.start_link(MarkovChain.Reducer.FrequencyReducer, self)

GenStage.sync_subscribe(d, to: c)
GenStage.sync_subscribe(c, to: b)
GenStage.sync_subscribe(b, to: a)

IO.puts "Generating frequency table..."
start_time = :erlang.monotonic_time(:milli_seconds)
freq_map = receive do
  {:done, map} -> map
end
end_time = :erlang.monotonic_time(:milli_seconds)
IO.puts "Finished generating frequency table in #{end_time - start_time}ms"

IO.puts "Indexing #{map_size(freq_map)} entries..."
start_time = :erlang.monotonic_time(:milli_seconds)
docs = Enum.map(freq_map, fn
    {:start, list} ->
      %{
        key: "_start_sequence",
        list: list
      }
    {:end, list} ->
      %{
        key: "_end_sequence",
        list: list
      }
    {word, list} ->
      %{
        key: word,
        list: list
      }
  end)
%{status_code: 200} = Elasticsearch.bulk_index("lirik_freq", "frequency_entry", docs)
end_time = :erlang.monotonic_time(:milli_seconds)
IO.puts "Finished indexing in #{end_time - start_time}ms"
