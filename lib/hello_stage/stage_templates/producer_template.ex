defmodule ProducerTemplate do
  use GenStage
  require Logger


  def start_link do
    start_args = :dont_care
    GenStage.start_link(__MODULE__, start_args, name: __MODULE__)
  end


  def init(_start_args) do
    initial_state = %SimpleDemandBuffer{}
    {:producer, initial_state}
  end


  def notify(new_events) when is_list(new_events) do
    GenStage.call(__MODULE__, {:notify, new_events})
  end


  def notify(new_event) do
    GenStage.call(__MODULE__, {:notify, [new_event]})
  end


  def handle_call({:notify, new_events}, from, buffer) do
    buffer = SimpleDemandBuffer.add_events(buffer, new_events)
    GenStage.reply(from, :ok)
    dispatch_events(buffer)
  end


  def handle_demand(demand, buffer) do
    Logger.debug("#{__MODULE__} incoming demand: #{demand}")
    buffer = SimpleDemandBuffer.register_demand(buffer, demand)
    dispatch_events(buffer)
  end


  defp dispatch_events(buffer) do
    if SimpleDemandBuffer.pending_demand?(buffer) do
      {:ok, buffer, events} = SimpleDemandBuffer.get_pending_demand(buffer)
      {:noreply, events, buffer}
    else
      {:noreply, [], buffer}
    end
  end
end
