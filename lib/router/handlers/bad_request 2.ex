defmodule HTTPServer.Router.Handlers.BadRequest do
  @behaviour HTTPServer.Handler

  @impl HTTPServer.Handler
  def handle(_req) do
    body = "Bad Request. Please check the formatting and try again."

    {400, body, :text}
  end
end
