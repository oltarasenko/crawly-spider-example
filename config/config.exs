use Mix.Config

config :crawly,
       pipelines: [
         Crawly.Pipelines.CSVEncoder,
         {Crawly.Pipelines.WriteToFile, folder: "/tmp", extension: "csv"}
       ]
