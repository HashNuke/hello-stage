defmodule SimpleConsumer do
  use GenStage
  require Logger


  def start_link do
    #Q Why use :ok
    start_args = :not_in_use
    GenStage.start_link(__MODULE__, start_args)
  end


  def init(_start_args) do
    #Q connect to multiple producers?
    {:consumer, :dont_care_about_state, subscribe_to: [SimpleProducer]}
  end


  def handle_events(events, _from, state) do
    # sleep for 3 seconds for fun
    # Process.sleep(3000)

    Enum.map(events, fn(event)->
      Logger.info("#{__MODULE__} received: #{inspect event}")
    end)

    {:noreply, [], state}
  end
end