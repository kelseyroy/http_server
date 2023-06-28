defmodule HTTPServer.Router.Handlers.Options do
  @behaviour HTTPServer.Handler

  @impl HTTPServer.Handler
  def handle(_req) do
    body = ""
    {200, body, :text}
  end
end
