defmodule Kword.MixProject do
  use Mix.Project

  def project do
    [
      app: :kword,
      version: "0.1.0",
      description: "A library of keyword-list handling functions to complement Keyword",
      licenses: ["Apache 2.0"],
      elixir: ">= 1.15.0",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, github: "elixir-lang/ex_doc", only: [:dev, :test], runtime: false},
      {:ex_check, "~> 0.12", only: [:dev, :test]},
      {:credo, ">= 0.0.0", only: [:dev, :test], runtime: false}
    ]
  end
end
