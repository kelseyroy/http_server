import Config

config :http_server,
  routes: HTTPServer.Routes

config :logger,
  backends: [:console]
