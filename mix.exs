defmodule Bump.Mixfile do
  use Mix.Project

  def project do
    [
      app: :mix_bump,
      version: "0.0.1",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps(),
      docs: docs(),
      description: description(),
      package: package(),
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
      {:ex_doc, "~> 0.18", only: :dev},
    ]
  end

  defp docs do
    [extras: ["README.md"]]
  end

  defp description do
    "This is a simple mix task to version bump a mix project."
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE.md"],
      maintainers: ["Milo Lee"],
      licenses: ["MIT"],
      links: %{"Github": "https://github.com/oo6/mix-bump"}
    ]
  end
end
