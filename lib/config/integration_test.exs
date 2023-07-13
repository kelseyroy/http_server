import Config

config :http_server,
  routes: HTTPServerFixture.Routes,
  file_path: "lib/http_server_fixture/data/test-data.json"

config :logger,
  backends: [:console],
  compile_time_purge_matching: [
    [level_lower_than: :error]
  ]
