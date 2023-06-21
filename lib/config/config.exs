import Config

config :http_server,
  env: config_env()

import_config "#{config_env()}.exs"
