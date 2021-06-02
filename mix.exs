defmodule EctoXml.MixProject do
  use Mix.Project

  def project do
    [
      app: :ecto_xml,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      description: description(),
      package: package(),
      deps: deps()
    ]
  end

  defp description do
    """
    Library for manipulating and validating IBAN account numbers.
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Pedro Bini"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/pedro-lb/ecto_xml"}
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
      {:xml_builder, "~> 2.1"},
      # Dev & Test
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:phoenix_ecto, "~> 4.1", only: [:dev, :test]},
      # Test
      {:excoveralls, "~> 0.14.0", only: :test}
    ]
  end
end
