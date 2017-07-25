defmodule BacklinkSearchV2.AddExtract do
  use GenStage
  require Logger

  def start_link do
    start_args = :not_in_use
    GenStage.start_link(__MODULE__, start_args)
  end


  def init(_start_args) do
    producers = [
      {BacklinkSearchV2.Search, max_demand: 3, min_demand: 0}
    ]
    {:consumer, :not_in_use, subscribe_to: producers}
  end


  def handle_events(events, _from, state) do
    Logger.debug("#{__MODULE__} received: #{inspect events}")

    Enum.map(events, fn(event)->
      extract = WikipediaApi.page_extract(event[:page_id])
      page_info = Map.put(event, :extract, extract)
      IO.puts(inspect page_info)
    end)

    {:noreply, [], state}
  end

end