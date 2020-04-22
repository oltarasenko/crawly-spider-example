defmodule CrawlyExamples.Spider.Homebase do
  @behaviour Crawly.Spider

  alias CrawlyExamples.ImageUtils

  require Logger

  @impl Crawly.Spider
  def base_url(), do: "https://www.homebase.co.uk"

  @impl Crawly.Spider
  def init() do
    [
      start_urls: [
        "https://www.homebase.co.uk/our-range/tools",
        "https://www.homebase.co.uk/our-range/lighting-and-electrical/lighting/torches-and-nightlights/worklights",
      ]
    ]
  end

  @impl Crawly.Spider
  def parse_item(response) do
    {:ok, document} = Floki.parse_document(response.body)

    # Extract product categories URLs
    product_categories =
      document
      |> Floki.find("div.product-list-footer a")
      |> Floki.attribute("href")

    # Extract individual product page URLs
    product_pages =
      document
      |> Floki.find("a.product-tile")
      |> Floki.attribute("href")

    urls = product_pages ++ product_categories

    # Convert URLs into Requests
    requests =
      urls
      |> Enum.uniq()
      |> Enum.map(&build_absolute_url/1)
      |> Enum.map(&Crawly.Utils.request_from_url/1)

    category =
      document
      |> Floki.find(".breadcrumb span")
      |> Enum.at(1)
      |> Floki.text()

    images = document |> Floki.find("img.rsTmb") |> Floki.attribute("src")

    # Create item (for pages where items exists)
    item = %{
      title: document |> Floki.find(".page-title h1") |> Floki.text(),
      id:
        document
        |> Floki.find(".product-header-heading span")
        |> Floki.text(),
      images: images,
      category: category,
      description:
        document
        |> Floki.find(".product-details__description")
        |> Floki.text()
    }

    Enum.each(images, fn url -> ImageUtils.save_image("Homebase", category, url) end)

    %Crawly.ParsedItem{:items => [item], :requests => requests}
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
end
