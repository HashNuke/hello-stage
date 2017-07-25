defmodule HelloStage.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(HelloStage.Repo, []),
      # Start the endpoint when the application starts
      supervisor(HelloStageWeb.Endpoint, []),
      # Start your own worker by calling: HelloStage.Worker.start_link(arg1, arg2, arg3)
      # worker(HelloStage.Worker, [arg1, arg2, arg3]),

      worker(SimpleProducer, []),
      worker(SimpleConsumer, []),

      worker(ProducerWithDemandLimits, []),
      worker(ConsumerWithDemandLimits, []),

      worker(GoodProducer, []),
      worker(GoodConsumer, []),

      worker(GoodProducerV2, []),
      worker(GoodConsumerV2, []),

      worker(HNSearch.Producer, []),
      worker(HNSearch.Consumer, []),

      worker(BacklinkSearch.Producer, []),
      worker(BacklinkSearch.Search, []),

      worker(BacklinkSearchV2.Producer, []),
      worker(BacklinkSearchV2.Search, []),
      worker(BacklinkSearchV2.AddExtract, [])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HelloStage.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    HelloStageWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
