defmodule ProducerWithDemandLimits do
  use GenStage
  require Logger


  def start_link do
    start_args = :dont_care
    GenStage.start_link(__MODULE__, start_args, name: __MODULE__)
  end


  def init(_start_args) do
    initial_state = :dont_care
    {:producer, initial_state, buffer_size: 10}
  end


  def notify(new_events) do
    GenStage.call(__MODULE__, {:notify, new_events})
  end


  def handle_call({:notify, new_events}, _from, state) do
    {:reply, :ok, new_events, state}
  end


  def handle_demand(demand, state) when demand > 0 do
    Logger.info "#{__MODULE__} incoming demand: #{demand}"

    events_to_send = []
    {:noreply, events_to_send, state}
  end
end
