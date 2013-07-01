defmodule EpgPool.Supervisor do
  use Supervisor.Behaviour

  def start_link do
    :supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    {:ok, pools} = :application.get_env(:epg_pool, :pools)
    init(pools)
  end

  def init(pools) do
    children = Enum.map(pools, fn({name, size_args, worker_args}) -> 
        pool_args = [{:name, {:local, name}}, {:worker_module, EpgPool.Worker}] ++ size_args
        :poolboy.child_spec(name, pool_args, worker_args)
    end)

    # See http://elixir-lang.org/docs/stable/Supervisor.Behaviour.html
    # for other strategies and supported options
    supervise(children, strategy: :one_for_one)
  end
end
