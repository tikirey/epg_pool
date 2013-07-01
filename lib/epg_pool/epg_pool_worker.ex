defmodule EpgPool.Worker do
  use GenServer.Behaviour

  def start_link(args) do
    :gen_server.start_link(__MODULE__, args, [])
  end

  def init(args) do
    {:ok, conn} = :pgsql.connect(args[:hostname], args[:username], args[:password], [database: args[:database]])
    {:ok, conn}
  end

  def handle_call({:squery, sql}, _from, conn) do
    {:reply, :pgsql.squery(conn, sql), conn}
  end

  def handle_call({:equery, stmt, params}, _from, conn) do
    {:reply, :pgsql.equery(conn, stmt, params), conn}
  end

  def handle_call(_req, _from, conn) do
    {:reply, :ok, conn}
  end

  def handle_cast(_msg, conn) do
    {:noreply, conn}
  end

  def handle_info(_info, conn) do
    {:noreply, conn}
  end

  def terminate(_reason, conn) do
    ok = :pgsql.close(conn)
    ok
  end

  def code_change(_old, conn, _extra) do
    {:ok, conn}
  end
end