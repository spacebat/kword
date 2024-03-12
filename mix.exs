defmodule Kword.MixProject do
  use Mix.Project

  def project do
    [
      app: :kword,
      version: "0.1.0",
      elixir: ">= 1.15.0",
      description: "A library of keyword-list handling functions to complement Keyword",
      package: package(),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      source_url: "https://github.com/spacebat/kword"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    []
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.31", only: [:dev], runtime: false},
      {:ex_check, "~> 0.16", only: [:dev, :test], runtime: false},
      {:credo, "~> 1.7.5", only: [:dev, :test], runtime: false}
    ]
  end

  def package() do
    [
      files: ~w(lib priv .formatter.exs mix.exs README* readme* LICENSE* license* CHANGELOG* changelog* src),
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/elixir-ecto/postgrex"}
    ]
  end
end
