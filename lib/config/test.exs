import Config

config :http_server,
  routes: HTTPServerTestFixture.MockRoutes,
  file_path: "lib/http_server_test_fixture/mock_data/test-data.json"

config :logger,
  backends: [:console],
  compile_time_purge_matching: [
    [level_lower_than: :error]
  ]
