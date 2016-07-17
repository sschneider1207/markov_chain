alias Experimental.GenStage

defmodule MarkovChain.ReducerStage do
  use GenStage

  def start_link(reducer, pid, opts \\ []) when is_atom(reducer) do
    GenStage.start_link(__MODULE__, [reducer, pid], opts)
  end

  def init([reducer, pid]) do
    {:consumer, {reducer, %{}, pid}}
  end

  def handle_events(events, _from, {reducer, acc, pid}) do
    acc = apply(reducer, :reduce, [events, acc])
    Process.sleep(250)
    {:noreply, [], {reducer, acc, pid}}
  end

  def handle_info({_tag, {:producer, :done}}, {_reducer, acc, pid} = state) do    
    send(pid, {:done, acc})
    {:noreply, [], state}
  end
end
