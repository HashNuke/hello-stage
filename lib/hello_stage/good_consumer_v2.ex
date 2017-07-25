defmodule GoodConsumerV2 do
  use GenStage
  require Logger


  def start_link do
    start_args = :not_in_use
    GenStage.start_link(__MODULE__, start_args)
  end


  def init(_start_args) do
    producers = [
      {GoodProducerV2, max_demand: 3, min_demand: 0}
    ]
    {:consumer, :not_in_use, subscribe_to: producers}
  end


  def handle_events(events, _from, state) do
    Logger.info("Received: #{inspect events}")

    # sleep for 3 seconds for fun
    Process.sleep(3000)
    {:noreply, [], state}
  end
end