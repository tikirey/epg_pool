defmodule EpgPool.Mixfile do
  use Mix.Project

  def project do
    [ app: :epg_pool,
      version: "0.0.1",
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    [mod: { EpgPool, [] }]
  end

  # Returns the list of dependencies in the format:
  # { :foobar, "0.1", git: "https://github.com/elixir-lang/foobar.git" }
  defp deps do
    [ { :poolboy, %r(.*), github: "devinus/poolboy" },
      { :epgsql, %r(.*), github: "wg/epgsql"}
    ]
  end
end
