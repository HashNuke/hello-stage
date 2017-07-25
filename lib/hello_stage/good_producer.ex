defmodule GoodProducer do
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



  def notify(new_event) do
    GenStage.call(__MODULE__, {:notify, [new_event]})
  end


  def handle_call({:notify, new_event}, _from, buffer) do
    buffer = SimpleDemandBuffer.add_events(buffer, [new_event])

    if SimpleDemandBuffer.pending_demand?(buffer) do
      {:ok, buffer, events} = SimpleDemandBuffer.get_pending_demand(buffer)
      {:reply, :ok, events, buffer}
    else
      {:reply, :ok, [], buffer}
    end
  end


  def handle_demand(demand, buffer) do
    Logger.debug("#{__MODULE__} incoming demand: #{demand}")
    buffer = SimpleDemandBuffer.register_demand(buffer, demand)

    if SimpleDemandBuffer.pending_demand?(buffer) do
      {:ok, buffer, events} = SimpleDemandBuffer.get_pending_demand(buffer)
      {:noreply, events, buffer}
    else
      {:noreply, [], buffer}
    end
  end
end