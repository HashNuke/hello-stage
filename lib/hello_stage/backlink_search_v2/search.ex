defmodule BacklinkSearchV2.Search do
  use GenStage
  require Logger


  def start_link do
    start_args = :not_in_use
    GenStage.start_link(__MODULE__, start_args, name: __MODULE__)
  end


  def init(_start_args) do
    producers = [
      {BacklinkSearchV2.Producer, max_demand: 3, min_demand: 0}
    ]
    {:producer_consumer, :not_in_use, subscribe_to: producers}
  end


  def handle_events(events, _from, state) do
    Logger.debug("#{__MODULE__} received: #{inspect events}")

    result_events = Enum.flat_map(events, fn(event)->
      results = WikipediaApi.backlinks(event)
      format_results(event, results)
    end)

    Logger.info("#{Enum.count(result_events)} results for #{inspect events}")
    {:noreply, result_events, state}
  end


  def format_results(keyword, results) do
    Enum.map(results, fn(result)->
      Map.put(result, :keyword, keyword)
    end)
  end

end
