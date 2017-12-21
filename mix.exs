defmodule Esub.Mixfile do
  use Mix.Project

  def project do
    [
      app: :esub,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      description: description(),
      package: package(),
      name: "Esub",
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Esub, []}
    ]
  end

  defp description do
    """
    A simple event subscription framework. 
    """
  end
  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Jessiah Ratliff"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/jessiahr/esub"}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.18", only: :dev}
    ]
  end
end
