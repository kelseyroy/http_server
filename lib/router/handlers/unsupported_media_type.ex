defmodule HTTPServer.Router.Handlers.UnsupportedMediaType do
  @behaviour HTTPServer.Handler

  @impl HTTPServer.Handler
  def handle(_req) do
    body = ""

    {415, body, :text}
  end
end
