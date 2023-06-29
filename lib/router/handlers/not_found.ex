defmodule HTTPServer.Router.Handlers.NotFound do
  alias HTTPServer.Request
  @behaviour HTTPServer.Handler

  @impl HTTPServer.Handler
  def handle(%Request{path: path}) do
    body =
      "The requested URL #{path} was not found on this server. See the README for instructions on how to customize your routes!"

    {404, body, :text}
  end
end
