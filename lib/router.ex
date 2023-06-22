defmodule HTTPServer.Router do
  alias HTTPServer.Response
  alias HTTPServer.Request
  alias HTTPServer.Handlers.NotFound
  alias HTTPServer.Routes.ClientRoutes

  @routes Application.compile_env(:http_server, :routes, ClientRoutes)

  def router(req) do
    case Map.fetch(@routes.routes, req.path) do
      {:ok, path_info} ->
        router(req, path_info)

      _ ->
        route_not_found(req)
    end
  end

  defp router(req = %Request{method: "OPTIONS"}, path_info) do
    {:ok, methods} = Map.fetch(path_info, :methods)
    headers = Response.build_headers(req.method, "", methods)
    Response.send_resp(200, "", headers)
  end

  defp router(req = %Request{method: "HEAD"}, path_info) do
    {:ok, handler} = Map.fetch(path_info, :handler)
    {status_code, body} = handler.handle(%{req | method: "GET"})
    headers = Response.build_headers(req.method, body)
    Response.send_resp(status_code, "", headers)
  end

  defp router(req, path_info) do
    {:ok, handler} = Map.fetch(path_info, :handler)
    {status_code, body} = handler.handle(req)
    headers = Response.build_headers(req.method, body)
    Response.send_resp(status_code, body, headers)
  end

  defp route_not_found(req) do
    {status_code, body} = NotFound.handle(req)
    headers = Response.build_headers(req.method, body)
    Response.send_resp(status_code, body, headers)
  end
end
