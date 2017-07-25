defmodule WikipediaApi do

  # Example usage:
  # Wikipedia.backlinks("Stack Overflow")
  # Wikipedia.page_info(2161929)
  # Wikipedia.page_extract(2161929)

  @api_url "https://en.wikipedia.org/w/api.php"


  def page_info(page_id) do
    # The API response returns page_id as a string key.
    # So just convert it here for all other purposes too.
    page_id = "#{page_id}"
    params = [
      action: "query",
      pageids: page_id,
      prop: "info",
      inprop: "url",
      format: "json"
    ]

    {:ok, response} = HTTPoison.get @api_url, [], params: params
    body = Poison.decode!(response.body)

    page_info = body["query"]["pages"][page_id]
    %{page_id: page_id, page_url: page_info["fullurl"], last_revision_id: page_info["lastrevid"]}
  end


  def page_extract(page_id) do
    # The API response returns page_id as a string key.
    # So just convert it here for all other purposes too.
    page_id = "#{page_id}"

    params = [
      action: "query",
      pageids: page_id,
      prop: "info",
      inprop: "url",
      prop: "extracts",
      explaintext: nil,
      exintro: nil,
      format: "json"
    ]

    {:ok, response} = HTTPoison.get @api_url, [], params: params
    body = Poison.decode!(response.body)

    page_info = body["query"]["pages"][page_id]
    page_info["extract"]
  end


  def backlinks(page_title) do
    params = [
      action: "query",
      bltitle: page_title,
      list: "backlinks",
      bllimit: 500,
      blfilterredir: "nonredirects",
      blnamespace: 0,
      format: "json"
    ]

    {:ok, response} = HTTPoison.get @api_url, [], params: params
    body = Poison.decode!(response.body)
    format_backlinks(body["query"]["backlinks"])
  end


  # Functions to format backlink data

  defp format_backlinks(backlinks) do
    format_backlinks(backlinks, [])
  end


  defp format_backlinks([], formatted_backlinks) do
    Enum.reverse(formatted_backlinks)
  end


  defp format_backlinks([backlink | backlinks], formatted_backlinks) do
    # Format the page id into string to be consistent everywhere else
    formatted_backlink = %{
      page_id: "#{backlink["pageid"]}",
      page_title: backlink["title"]
    }

    backlinks
    |> format_backlinks([formatted_backlink | formatted_backlinks])
  end
end
