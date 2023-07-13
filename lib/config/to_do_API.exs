import Config

config :http_server,
  routes: ToDo.Routes,
  file_path: "lib/to_do/data/to_dos.json"


config :logger,
  backends: [:console]
