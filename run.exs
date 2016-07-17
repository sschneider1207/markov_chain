Application.ensure_started(:markov_chain)

IO.puts "Pulling elastic search data..."
%{hits: hits} = Elasticsearch.query("lirik", "chat_message", "*:*", 0, 50_000)
list = Enum.map(hits, &get_in(&1, ["_source", "text"]))
IO.puts "Found #{length(list)} documents."

tokenizer = MarkovChain.Tokenizer.SimpleTokenizer
analyzer = MarkovChain.Analyzer.FrequencyAnalyzer
reducer = MarkovChain.Reducer.FrequencyReducer

IO.puts "Generating frequency table..."
start_time = :erlang.monotonic_time(:milli_seconds)
freq_map = MarkovChain.init(list, tokenizer, analyzer, reducer, 5)
end_time = :erlang.monotonic_time(:milli_seconds)
IO.puts "Finished generating frequency table in #{end_time - start_time}ms"

index = false
if index do
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
end
