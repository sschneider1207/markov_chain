alias Experimental.GenStage

defmodule MarkovChain.TokenizerStage do
  use GenStage

  @spec start_link(MarkovChain.Tokenizer.t, GenStage.options) :: GenServer.on_start
  def start_link(tokenizer, opts \\ []) do
    Code.ensure_loaded?(tokenizer)
    unless :erlang.function_exported(tokenizer, :tokenize, 1) do
      raise "Module #{tokenizer} does not implement the #{MarkovChain.Tokenizer} behaviour."
    end
    GenStage.start_link(__MODULE__, tokenizer, opts)
  end

  @doc false
  def init(tokenizer) do
    {:producer_consumer, {tokenizer, []}}
  end

  @doc false
  def handle_events(events, _from, {tokenizer, consumers}) do
    events = Enum.map(events, &apply(tokenizer, :tokenize, [&1]))
    {:noreply, events, {tokenizer, consumers}}
  end

  @doc false
  def handle_subscribe(:consumer, _opts, {pid, _ref}, {tokenizer, consumers}) do
    {:automatic, {tokenizer, [pid|consumers]}}
  end
  def handle_subscribe(_arg, _opts, _id, state) do
    {:automatic, state}
  end

  @doc false
  def handle_info({_tag, {:producer, :done}}, {tokenizer, consumers}) do
    Enum.each(consumers, &GenStage.sync_notify(&1, {:producer, :done}))
    {:noreply, [], {tokenizer, consumers}}
  end
end
