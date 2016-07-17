alias Experimental.GenStage

defmodule MarkovChain.AnalyzerStage do
  use GenStage

  def start_link(analyzer, opts \\ []) when is_atom(analyzer) do
    GenStage.start_link(__MODULE__, analyzer, opts)
  end

  def init(analyzer) do
    {:producer_consumer, {analyzer, []}}
  end

  def handle_events(events, _from, {analyzer, consumers}) do
    events = Enum.map(events, &apply(analyzer, :analyze, [&1]))
    {:noreply, events, {analyzer, consumers}}
  end

  def handle_subscribe(:consumer, _opts, {pid, ref}, {analyzer, consumers}) do
    {:automatic, {analyzer, [pid|consumers]}}
  end
  def handle_subscribe(_arg, _opts, _id, state) do
    {:automatic, state}
  end

  def handle_info({_tag, {:producer, :done}}, {analyzer, consumers}) do
    Enum.each(consumers, &GenStage.sync_notify(&1, {:producer, :done}))
    {:noreply, [], {analyzer, consumers}}
  end
end
