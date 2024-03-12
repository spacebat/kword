defmodule Kword.MixProject do
  use Mix.Project

  @version "0.1.0"
  @source_url "https://github.com/spacebat/kword"

  def project do
    [
      app: :kword,
      version: @version,
      name: "Kword",
      elixir: ">= 1.15.0",
      package: package(),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs(),
      source_url: @source_url
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    []
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # dev and test dependencies
      {:ex_doc, "~> 0.31", only: [:dev], runtime: false},
      {:ex_check, "~> 0.16", only: [:dev, :test], runtime: false},
      {:credo, "~> 1.7.5", only: [:dev, :test], runtime: false}
    ]
  end

  def package do
    [
      name: "Kword",
      description: "A library of keyword-list handling functions to complement Keyword",
      maintainers: "Andy Kirkatrick",
      licenses: ["Apache-2.0"],
      links: %{
        "GitHub" => @source_url
      }
    ]
  end

  def docs do
    [
      extras: [
        "CHANGELOG.md": [title: "Changelog"],
        "LICENSE.md": [title: "License"],
        "README.md": [title: "Overview"]
      ],
      main: "readme",
      source_url: @source_url,
      source_ref: "v#{@version}",
      formatters: ["html"]
    ]
  end
end
