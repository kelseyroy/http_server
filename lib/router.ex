defmodule HTTPServer.Router do
  alias HTTPServer.Response
  alias HTTPServer.Request
  alias HTTPServer.Handlers.NotFound
  alias HTTPServer.Routes

  @routes Application.compile_env(:http_server, :routes, Routes)

  def router(req) do
    case Map.fetch(@routes.routes, req.path) do
      {:ok, path_info} ->
        router(req, path_info)

      _ ->
        route_not_found(req)
    end
  end

  defp router(_req = %Request{method: "OPTIONS"}, path_info) do
    {:ok, methods} = Map.fetch(path_info, :methods)
    allow_header = Response.build_allow_header(methods)
    headers = Response.build_headers("", allow_header)
    Response.send_resp(200, "", headers)
  end

  defp router(req = %Request{method: "HEAD"}, path_info) do
    {:ok, handler} = Map.fetch(path_info, :handler)
    {status_code, _body, headers} = handler.handle(%{req | method: "GET"})
    Response.send_resp(status_code, "", headers)
  end

  defp router(req, path_info) do
    {:ok, handler} = Map.fetch(path_info, :handler)
    {status_code, body, headers} = handler.handle(req)
    Response.send_resp(status_code, body, headers)
  end

  defp route_not_found(req) do
    {status_code, body, headers} = NotFound.handle(req)
    Response.send_resp(status_code, body, headers)
  end
end
