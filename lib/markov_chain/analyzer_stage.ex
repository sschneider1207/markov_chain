alias Experimental.GenStage

defmodule MarkovChain.AnalyzerStage do
  use GenStage

  @spec start_link(MarkovChain.Analyzer.t, GenStage.options) :: GenServer.on_start
  def start_link(analyzer, opts \\ []) do
    Code.ensure_loaded?(analyzer)
    unless :erlang.function_exported(analyzer, :analyze, 1) do
      raise "Module #{analyzer} does not implement the #{MarkovChain.Analyzer} behaviour."
    end
    GenStage.start_link(__MODULE__, analyzer, opts)
  end

  @doc false
  def init(analyzer) do
    {:producer_consumer, {analyzer, []}}
  end

  @doc false
  def handle_events(events, _from, {analyzer, consumers}) do
    events = Enum.map(events, &apply(analyzer, :analyze, [&1]))
    {:noreply, events, {analyzer, consumers}}
  end

  @doc false
  def handle_subscribe(:consumer, _opts, {pid, _ref}, {analyzer, consumers}) do
    {:automatic, {analyzer, [pid|consumers]}}
  end
  def handle_subscribe(_arg, _opts, _id, state) do
    {:automatic, state}
  end

  @doc false
  def handle_info({_tag, {:producer, :done}}, {analyzer, consumers}) do
    Enum.each(consumers, &GenStage.sync_notify(&1, {:producer, :done}))
    {:noreply, [], {analyzer, consumers}}
  end
end
