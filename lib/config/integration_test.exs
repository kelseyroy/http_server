import Config

config :http_server,
  routes: HTTPServerFixture.Routes,
  file_path: "lib/to_do/data/to_dos.json"

config :logger,
  backends: [:console],
  compile_time_purge_matching: [
    [level_lower_than: :error]
  ]
