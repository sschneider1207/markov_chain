alias Experimental.GenStage

defmodule MarkovChain.ReducerStage do
  use GenStage

  @spec start_link(MarkovChain.Reducer.t, pid, GenStage.options) :: GenServer.on_start
  def start_link(reducer, pid, opts \\ []) do
    Code.ensure_loaded?(reducer)
    unless :erlang.function_exported(reducer, :reduce, 2) do
      raise "Module #{reducer} does not implement the #{MarkovChain.Reducer} behaviour."
    end
    GenStage.start_link(__MODULE__, [reducer, pid], opts)
  end

  @doc false
  def init([reducer, pid]) do
    {:consumer, {reducer, %{}, pid}}
  end

  @doc false
  def handle_events(events, _from, {reducer, acc, pid}) do
    IO.inspect {self, :erlang.monotonic_time} # to see progress
    acc = apply(reducer, :reduce, [events, acc])
    #Process.sleep(250)
    {:noreply, [], {reducer, acc, pid}}
  end

  @doc false
  def handle_info({_tag, {:producer, :done}}, {_reducer, acc, pid} = state) do
    send(pid, {:done, acc})
    {:noreply, [], state}
  end
end
