defmodule CrawlyExamples.Spider.Esl do
  @behaviour Crawly.Spider

  @impl Crawly.Spider
  def base_url() do
    "https://www.erlang-solutions.com"
  end

  @impl Crawly.Spider
  def init() do
    [
      start_urls: ["https://www.erlang-solutions.com/blog.html"]
    ]
  end

  @impl Crawly.Spider
  def parse_item(response) do
    # Getting new urls to follow
    {:ok, document} = Floki.parse_document(response.body)

    urls =
      document
      |> Floki.find("a.more")
      |> Floki.attribute("href")

    # Convert URLs into requests
    requests =
      urls
      |> Enum.map(fn url -> url |> build_absolute_url(response.request_url) |> Crawly.Utils.request_from_url() end)

    # Extract item from a page, e.g.
    # https://www.erlang-solutions.com/blog/introducing-telemetry.html
    title =
      document
      |> Floki.find("article.blog_post h1:first-child")
      |> Floki.text()

    author =
      document
      |> Floki.find("article.blog_post p.subheading")
      |> Floki.text(deep: false, sep: "")
      |> String.trim_leading()
      |> String.trim_trailing()

    text =
      document
      |> Floki.find("article.blog_post") |> Floki.text()

    %Crawly.ParsedItem{
      :requests => requests,
      :items => [
        %{title: title, author: author, text: text, url: response.request_url}
      ]
    }
  end

  @impl Crawly.Spider
  def override_settings() do
    [
      pipelines: [
        {Crawly.Pipelines.CSVEncoder, fields: ~w(title author text url)a},
        {Crawly.Pipelines.WriteToFile, folder: "/tmp", extension: "csv"},
      ]
    ]
  end

  defp build_absolute_url(url, request_url), do: URI.merge(request_url, url) |> to_string()
end
