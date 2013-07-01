# EpgPool

## Application starting

    pools = [
      {:main_pool, 
        [size: 2, max_overflow: 0],
        [
          hostname: '127.0.0.1',
          database: 'database',
          username: 'postgres',
          password: 'test'
        ]
      }
    ]
    :application.set_env(:epg_pool, :pools, pools)
    :ok = :application.start(:epg_pool)

## Query

    EpgPool.sq("SELECT ...") # will query to :main_pool

    EpgPool.sq(:poll_name, "SELECT") # will query to pool with ':poll_name'

