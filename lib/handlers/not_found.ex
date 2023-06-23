defmodule HTTPServer.Handlers.NotFound do
  alias HTTPServer.Response
  @behaviour HTTPServer.Handler

  @impl HTTPServer.Handler
  def handle(req) do
    body =
      "The requested URL #{req.path} was not found on this server. See the README for instructions on how to customize your routes!"

    {404, body, Response.build_headers(body)}
  end
end
