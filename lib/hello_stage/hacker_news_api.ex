defmodule HackerNewsApi do

  @search_url "https://hn.algolia.com/api/v1/search"

  # HackerNews.top3_comments(11116274)
  def top3_comments(story_id) do
    {:ok, response} = HTTPoison.get @search_url, [], params: [tags: "comment,story_#{story_id}"]

    Poison.decode!(response.body)["hits"]
    |> Enum.take(3)
    |> format_comments()
  end


  # HackerNews.search_stories("privacy")
  def search_stories(search_string) do
    {:ok, response} = HTTPoison.get @search_url, [], params: [query: search_string, tags: "story"]

    Poison.decode!(response.body)["hits"]
    |> format_stories()
  end


  # Format comments

  defp format_comments(results) do
    format_comments(results, [])
  end


  defp format_comments([], formatted_results) do
    formatted_results
  end


  defp format_comments([result | results], formatted_results) do
    formatted_result = %{
      comment_id: result["objectID"],
      created_at: result["created_at"],
      text: result["comment_text"],
      author: result["author"],
    }

    format_comments(results, [formatted_result | formatted_results])
  end


  # Format stories

  defp format_stories(results) do
    format_stories(results, [])
  end


  defp format_stories([], formatted_results) do
    Enum.reverse(formatted_results)
  end


  defp format_stories([result | results], formatted_results) do
    formatted_result = %{
      story_id: result["objectID"],
      title: result["title"],
      created_at: result["created_at"],
      author: result["author"],
      comment_count: result["num_comments"]
    }

    format_stories(results, [formatted_result | formatted_results])
  end
end
