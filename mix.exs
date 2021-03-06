defmodule CrawlyExamples.MixProject do
  use Mix.Project

  def project do
    [
      app: :crawly_examples,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {CrawlyExamples.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:crawly, "~> 0.9.0"},
      {:floki, "~> 0.26.0"},
      {:exmagic, git: "https://github.com/andrew-d/exmagic.git", tag: "v0.0.2"},
      {:clipboard, ">= 0.0.0", only: [:dev]},
    ]
  end
end
