use Mix.Config

config :crawly,
       pipelines: [
         Crawly.Pipelines.JSONEncoder,
         {Crawly.Pipelines.WriteToFile, folder: "/tmp", extension: "json"},
       ]
