defmodule HTTPServer.Router.Handlers.BadRequest do
  @behaviour HTTPServer.Handler

  @impl HTTPServer.Handler
  def handle(_req) do
    body = ""

    {400, body, :text}
  end
end
