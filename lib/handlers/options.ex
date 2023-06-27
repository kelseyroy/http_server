defmodule HTTPServer.Handlers.Options do
  alias HTTPServer.Response.Headers
  import HTTPServer.Response.HeadersBuilder
  @behaviour HTTPServer.Handler
  @routes Application.compile_env(:http_server, :routes, Routes)

  @impl HTTPServer.Handler
  def handle(req) do
    methods = @routes.routes[req.path][:methods]

    body = ""

    headers =
      %Headers{}
      |> content_length(body)
      |> content_type()
      |> host(req.headers)
      |> allow(methods)

    {200, body, headers}
  end
end
