defmodule TextClient.MixProject do
  use Mix.Project

  def project do
    [
      app: :text_client,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      included_applications: [:tafl],
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:tafl, path: "../tafl"}
    ]
  end
end
