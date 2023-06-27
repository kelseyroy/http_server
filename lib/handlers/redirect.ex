defmodule HTTPServer.Handlers.Redirect do
  alias HTTPServer.Response
  import HTTPServer.Response.HeadersBuilder
  @behaviour HTTPServer.Handler
  @routes Application.compile_env(:http_server, :routes, Routes)

  @impl HTTPServer.Handler
  def handle(req) do
    {:ok, path_info} = Map.fetch(@routes.routes, req.path)
    {:ok, location} = Map.fetch(path_info, :location)
    body = ""

    headers =
      Response.build_headers()
      |> content_length(body)
      |> content_type()
      |> host(req.headers)
      |> location(req.headers, location)

    {301, body, headers}
  end
end
