defmodule SimpleProducer do
  use GenStage
  require Logger


  def start_link do
    start_args = :dont_care
    GenStage.start_link(__MODULE__, start_args, name: __MODULE__)
  end


  def init(_start_args) do
    initial_state = []
    {:producer, initial_state}
  end


  def notify(new_event) do
    GenStage.call(__MODULE__, {:notify, new_event})
  end


  def handle_call({:notify, new_event}, _from, state) do
    {:reply, :ok, [new_event], state}
  end


  def handle_demand(demand, state) do
    Logger.info "#{__MODULE__} incoming demand: #{demand}"
    events_to_send = []
    {:noreply, events_to_send, state}
  end

end