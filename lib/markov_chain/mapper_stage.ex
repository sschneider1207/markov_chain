alias Experimental.GenStage

defmodule MarkovChain.MapperStage do
  use GenStage

  @type mapper :: :tokenizer | :filter | :analyzer

  @spec start_link(mapper, module, GenStage.options) :: GenServer.on_start
  def start_link(type, mod, opts \\ []) do
    GenStage.start_link(__MODULE__, [type, mod], opts)
  end

  @doc false
  def init([type, mod]) do
    state = %{
      type: type,
      mod: mod,
      consumers: []
    }
    {:producer_consumer, state}
  end

  @doc false
  def handle_events(events, _from, state) do
    events = Enum.map(events, mapper(state.type, state.mod))
    {:noreply, events, state}
  end

  defp mapper(:tokenizer, mod) do
    &mod.tokenize(&1)
  end
  defp mapper(:filter, mod) do
    &mod.filter(&1)
  end
  defp mapper(:analyzer, mod) do
    &mod.analyze(&1)
  end

  @doc false
  def handle_subscribe(:consumer, _opts, {pid, _ref}, state) do
    {:automatic, %{state | consumers: [pid|state.consumers]}}
  end
  def handle_subscribe(_arg, _opts, _id, state) do
    {:automatic, state}
  end

  @doc false
  def handle_info({_tag, {:producer, :done}}, state) do
    Enum.each(state.consumers, &GenStage.sync_notify(&1, {:producer, :done}))
    {:noreply, [], state}
  end
end
