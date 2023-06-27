defmodule HTTPServer.Handlers.NotFound do
  alias HTTPServer.Response
  import HTTPServer.Response.HeadersBuilder
  @behaviour HTTPServer.Handler

  @impl HTTPServer.Handler
  def handle(req) do
    body =
      "The requested URL #{req.path} was not found on this server. See the README for instructions on how to customize your routes!"

    headers =
      Response.build_headers()
      |> content_length(body)
      |> content_type()
      |> host(req.headers)

    {404, body, headers}
  end
end
