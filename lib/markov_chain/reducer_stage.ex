alias Experimental.GenStage

defmodule MarkovChain.ReducerStage do
  use GenStage

  @spec start_link(MarkovChain.Reducer.t, pid, GenStage.options) :: GenServer.on_start
  def start_link(reducer, pid, opts \\ []) do
    GenStage.start_link(__MODULE__, [reducer, pid], opts)
  end

  @doc false
  def init([reducer, pid]) do
    state = %{
      mod: reducer,
      reporter: pid,
      acc: reducer.init()
    }
    {:consumer, state}
  end

  @doc false
  def handle_events(events, _from, state) do
    acc = state.mod.reduce(events, state.acc)
    {:noreply, [], %{state | acc: acc}}
  end

  @doc false
  def handle_info({_tag, {:producer, :done}}, state) do
    acc = case :erlang.function_exported(state.mod, :finalize, 1) do
      true -> state.mod.finalize(state.acc)
      false -> state.acc
    end
    send(state.reporter, {:done, acc})
    {:noreply, [], %{state | acc: state.mod.init()}}
  end
end
