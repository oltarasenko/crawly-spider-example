# CrawlyExamples

## Running the spiders
1. Run `mix deps.get`
1. Start interactive console: `iex -S mix`
1. Schedule one of the spiders: 
   * `Crawly.Engine.start_spider(CrawlyExamples.Spider.ClassicCars)` or
   * `Crawly.Engine.start_spider(CrawlyExamples.Spider.Esl)` or
   * `Crawly.Engine.start_spider(CrawlyExamples.Spider.Homebase)` or
   * `Crawly.Engine.start_spider(CrawlyExamples.Spider.WorldwideVintageAutos)`
1. Find the data in `/tmp/`
