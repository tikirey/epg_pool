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
        {:ok, columns, rows} = :gen_server.call(worker, {:squery, sql})

        cr_to_keyword_list(columns, rows)
      end)
  end

  defp cr_to_keyword_list(columns, rows) do
    # Right to left - keep order
    List.foldr(rows, [], fn (row, acc) -> 

      # Join columns names with actual data
      { _, result } = Enum.reduce(columns, {0, []}, fn(column, {count, acc}) ->

        key = binary_to_atom( elem(column, 1) )

        value = elem( row, count )

        { count + 1, Keyword.put(acc, key, value) }

      end)

      acc ++ [result]
    end)
  end # cr_to_keyword_list(columns, rows)
end
