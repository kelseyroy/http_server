defmodule HTTPServer.Router.Handlers.NotFound do
  alias HTTPServer.Request
  @behaviour HTTPServer.Handler

  @impl HTTPServer.Handler
  def handle(%Request{route_path: path}) do
    body =
      "Something went wrong at #{path}. See the README for instructions on how to customize your routes!"

    {404, body, :text}
  end
end
