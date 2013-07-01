defmodule EpgPool do
  use Application.Behaviour

  # See http://elixir-lang.org/docs/stable/Application.Behaviour.html
  # for more information on OTP Applications
  def start(_type, _args) do
    EpgPool.Supervisor.start_link
  end

  def sq(sql) when is_binary(sql) do
    sq(:main_pool, sql)
  end

  def sq(pool, sql) do
    :poolboy.transaction(pool, 
      fn(worker) -> 
        :gen_server.call(worker, {:squery, sql}) 
      end)
  end
end
