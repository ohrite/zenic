defmodule Zenic.MixProject do
  use Mix.Project

  def project do
    [
      app: :zenic,
      version: "0.1.0",
      elixir: "~> 1.9",
      build_embedded: true,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env()),
      deps_path: "../deps.nosync",
      build_path: "../_build.nosync"
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
      {:scenic, "~> 0.11.0"},
      {:scenic_driver_local, "~> 0.11.0"},
      {:dialyxir, "~> 1.3", only: [:dev], runtime: false}
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
