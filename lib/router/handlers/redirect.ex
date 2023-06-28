defmodule HTTPServer.Router.Handlers.Redirect do
  @behaviour HTTPServer.Handler

  @impl HTTPServer.Handler
  def handle(_req) do
    body = ""
    {301, body, :text}
  end
end
