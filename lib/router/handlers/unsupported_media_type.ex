defmodule HTTPServer.Router.Handlers.UnsupportedMediaType do
  @behaviour HTTPServer.Handler

  @impl HTTPServer.Handler
  def handle(_req) do
    body = "Unsupported Media Type"

    {415, body, :text}
  end
end
