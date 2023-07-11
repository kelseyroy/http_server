defmodule HTTPServer.Router.Handlers.UnsupportedMediaType do
  @behaviour HTTPServer.Handler

  @impl HTTPServer.Handler
  def handle(_req) do
    body = "Unsupported Format."
    {415, body, :text}
  end
end
