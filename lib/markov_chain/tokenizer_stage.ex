alias Experimental.GenStage

defmodule MarkovChain.TokenizerStage do
  use GenStage

  def start_link(tokenizer, opts \\ []) when is_atom(tokenizer) do
    GenStage.start_link(__MODULE__, tokenizer, opts)
  end

  def init(tokenizer) do
    {:producer_consumer, {tokenizer, []}}
  end

  def handle_events(events, _from, {tokenizer, consumers}) do
    events = Enum.map(events, &apply(tokenizer, :tokenize, [&1]))
    {:noreply, events, {tokenizer, consumers}}
  end

  def handle_subscribe(:consumer, _opts, {pid, ref}, {tokenizer, consumers}) do
    {:automatic, {tokenizer, [pid|consumers]}}
  end
  def handle_subscribe(_arg, _opts, _id, state) do
    {:automatic, state}
  end

  def handle_info({_tag, {:producer, :done}}, {tokenizer, consumers}) do
    Enum.each(consumers, &GenStage.sync_notify(&1, {:producer, :done}))
    {:noreply, [], {tokenizer, consumers}}
  end
end
