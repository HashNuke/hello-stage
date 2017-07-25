defmodule HNSearch.Consumer do
  use GenStage
  require Logger


  def start_link do
    start_args = :not_in_use
    GenStage.start_link(__MODULE__, start_args)
  end


  def init(_start_args) do
    producers = [
      {HNSearch.Producer, max_demand: 3, min_demand: 0}
    ]
    {:consumer, :not_in_use, subscribe_to: producers}
  end


  def handle_events(events, _from, state) do
    Logger.info("Received: #{inspect events}")

    Enum.map(events, fn(event)->
      results = HackerNewsApi.search_stories(event)
      print_results(event, results)
    end)

    {:noreply, [], state}
  end


  def print_results(keyword, results) do
    Enum.map(results, fn(result)->
      output = "[#{keyword}]: #{result[:title]} (#{result[:author]}, #{result[:comment_count]} comments)"
      IO.puts(output)
    end)
  end

end
