defmodule HTTPServer.Handlers.NotFound do
  @behaviour HTTPServer.Handler

  @impl HTTPServer.Handler
  def handle(req) do
    {404, "The requested URL #{req.path} was not found on this server. See the README for instructions on how to customize your routes!"}
  end
end
