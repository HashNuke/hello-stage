defmodule ProducerTemplate do
  use GenStage
  require Logger


  def start_link do
    start_args = :dont_care
    GenStage.start_link(__MODULE__, start_args, name: __MODULE__)
  end


  def init(_start_args) do
    initial_state = %DemandBuffer{}
    {:producer, initial_state}
  end


  def notify(new_events) when is_list(new_events) do
    GenStage.call(__MODULE__, {:notify, new_events})
  end


  def notify(new_event) do
    GenStage.call(__MODULE__, {:notify, [new_event]})
  end


  def handle_call({:notify, new_events}, from, buffer) do
    buffer = DemandBuffer.add_events(buffer, new_events)
    GenStage.reply(from, :ok)
    dispatch_events(buffer)
  end


  def handle_demand(demand, buffer) do
    Logger.debug("#{__MODULE__} incoming demand: #{demand}")
    buffer = DemandBuffer.register_demand(buffer, demand)
    dispatch_events(buffer)
  end


  defp dispatch_events(buffer) do
    {:ok, buffer, events} = DemandBuffer.get_pending_demand(buffer)
    {:noreply, events, buffer}
  end
end
