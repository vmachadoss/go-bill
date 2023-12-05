defmodule GoBillManager.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    :opentelemetry_cowboy.setup()
    OpentelemetryPhoenix.setup(adapter: :cowboy2)

    children = [
      # Start the Ecto repository
      GoBillManager.Repo,
      # Start the Telemetry supervisor
      GoBillManagerWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: GoBillManager.PubSub},
      # Start the Endpoint (http/https)
      GoBillManagerWeb.Endpoint
      # Start a worker by calling: GoBillManager.Worker.start_link(arg)
      # {GoBillManager.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GoBillManager.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    GoBillManagerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
