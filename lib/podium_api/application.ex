defmodule PodiumApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PodiumApiWeb.Telemetry,
      # PodiumApi.Repo,
      {DNSCluster, query: Application.get_env(:podium_api, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: PodiumApi.PubSub},
      # Start a worker by calling: PodiumApi.Worker.start_link(arg)
      # {PodiumApi.Worker, arg},
      # Start to serve requests, typically the last entry
      PodiumApiWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PodiumApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PodiumApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
