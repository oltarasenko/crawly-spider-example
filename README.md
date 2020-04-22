# CrawlyExamples

## Running the spider
1. Run `mix deps.get`
1. Start interactive console: `iex -S mix`
1. Schedule the spider `Crawly.Engine.start_spider(CrawlyExamples.Spider.Esl)`
1. Find the data in `/tmp/`
1. Repeat the process for other spiders found in `lib/crawly_examples/spider`
