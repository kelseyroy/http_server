defmodule HTTPServer.Router.Handlers.MethodNotAllowed do
  @behaviour HTTPServer.Handler

  @impl HTTPServer.Handler
  def handle(_req) do
    body = ""
    {405, body, :text}
  end
end
