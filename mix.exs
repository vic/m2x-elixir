defmodule M2X.Mixfile do
  use Mix.Project

  def project do
    [ app:     :m2x,
      version: "0.0.1",
      elixir:  "~> 1.1-dev",
      deps:    deps ]
  end

  # Configuration for the OTP application
  def application do
    [ applications: [:logger] ]
  end

  # Dependencies
  defp deps do
    []
  end
end
