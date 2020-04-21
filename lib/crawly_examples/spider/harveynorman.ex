defmodule CrawlyExamples.Spider.Harveynorman do
  alias CrawlyExamples.ImageUtils
  @behaviour Crawly.Spider

  require Logger
  @impl Crawly.Spider
  def base_url(), do: "https://www.harveynorman.ie"

  @impl Crawly.Spider
  def init() do
    [
      start_urls: [
        "https://www.harveynorman.ie/tvs-headphones/"
      ]
    ]
  end

  @impl Crawly.Spider
  def parse_item(response) do
    {:ok, document} = Floki.parse_document(response.body)

    pagination_urls =
      document |> Floki.find("ol.pager li a") |> Floki.attribute("href")

    product_urls =
      document |> Floki.find("a.product-img") |> Floki.attribute("href")

    all_urls = pagination_urls ++ product_urls

    requests =
      all_urls
      |> Enum.map(&build_absolute_url/1)
      |> Enum.map(&Crawly.Utils.request_from_url/1)
      |> Enum.map(fn request -> Crawly.Request.new(request.url, [], ssl: [versions: [:"tlsv1.2"]]) end)

    # Extracting items
    title = document |> Floki.find("h1.product-title") |> Floki.text()
    id = document |> Floki.find(".product-id") |> Floki.text()

    category =
      document
      |> Floki.find(".nav-breadcrumbs :nth-child(3)")
      |> Floki.text()

    description =
      document |> Floki.find(".product-tab-wrapper") |> Floki.text()

    images =
      document
      |> Floki.find(".pict")
      |> Floki.attribute("src")
      |> Enum.map(&build_image_url/1)

    Enum.each(images, fn url -> save_image(category, url) end)

    %Crawly.ParsedItem{
      :items => [
        %{
          id: id,
          title: title,
          category: category,
          images: images,
          description: description
        }
      ],
      :requests => requests
    }
  end


  @impl Crawly.Spider
  def override_settings() do
    [
      pipelines: [
        Crawly.Pipelines.JSONEncoder,
        {Crawly.Pipelines.WriteToFile, folder: "/tmp", extension: "json"},
      ]
    ]
  end

  defp build_absolute_url(url), do: URI.merge(base_url(), url) |> to_string()

  defp build_image_url(url), do: URI.merge("https://hniesfp.imgix.net", url) |> to_string()

  defp save_image(category, url), do: ImageUtils.save_image(category, url)
end
