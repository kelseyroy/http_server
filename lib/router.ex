defmodule HTTPServer.Router do
  alias HTTPServer.Response
  alias HTTPServer.Request
  alias HTTPServer.Handlers.NotFound
  alias HTTPServer.Handlers.Options
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

  defp router(req = %Request{method: "OPTIONS"}, _path_info) do
    {status_code, body, headers} = Options.handle(req)
    Response.send_resp(status_code, body, headers)
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
