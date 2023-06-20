defmodule HTTPServer.Routes.ClientRoutes do
  alias HTTPServer.Request
  alias HTTPServer.Handlers.NotFound

  @behaviour HTTPServer.Routes

  @routes %{}
  @impl HTTPServer.Routes
  def fetch_route(path) do
    Map.fetch(@routes, path)
  end

  @impl HTTPServer.Routes
  def route(%Request{path: _path} = req), do: NotFound.handle(req)
end
