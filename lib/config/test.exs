import Config

config :http_server,
  routes: HTTPServerTestFixture.MockRoutes

config :logger,
  backends: [:console],
  compile_time_purge_matching: [
    [level_lower_than: :error]
  ]
