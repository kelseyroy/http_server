defmodule HTTPServer.Handlers.Redirect do
  alias HTTPServer.Response
  @behaviour HTTPServer.Handler
  @routes Application.compile_env(:http_server, :routes, Routes)

  @impl HTTPServer.Handler
  def handle(req) do
    {:ok, path_info} = Map.fetch(@routes.routes, req.path)
    {:ok, location} = Map.fetch(path_info, :location)
    location_header = Response.build_location_header(location)
    {301, "", Response.build_headers("", location_header)}
  end
end
