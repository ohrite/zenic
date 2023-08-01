defmodule Example.MixProject do
  use Mix.Project

  def project do
    [
      app: :example,
      version: "0.1.0",
      elixir: "~> 1.9",
      build_embedded: true,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      deps_path: "../deps.nosync",
      build_path: "../_build.nosync"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Example, []},
      extra_applications: [:crypto]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:scenic, "~> 0.11.0"},
      {:scenic_driver_local, "~> 0.11.0"},
      {:zenic, path: ".."}
    ]
  end
end
