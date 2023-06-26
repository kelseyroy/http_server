defmodule HTTPServer.Router do
  alias HTTPServer.Handlers.MethodNotAllowed
  alias HTTPServer.Response
  alias HTTPServer.Request
  alias HTTPServer.Handlers.NotFound
  alias HTTPServer.Handlers.Options
  alias HTTPServer.Routes

  @routes Application.compile_env(:http_server, :routes, Routes)

  def router(req) do
    with {:ok, path_info} <- Map.fetch(@routes.routes, req.path),
         true <- is_method_allowed(req.method, path_info) do
      router(req, path_info)
    else
      :error -> route_not_found(req)
      false -> method_not_allowed(req)
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

  defp method_not_allowed(req) do
    {status_code, body, headers} = MethodNotAllowed.handle(req)
    Response.send_resp(status_code, body, headers)
  end

  defp is_method_allowed(req_method, path_info) do
    {:ok, methods} = Map.fetch(path_info, :methods)
    head = req_method == "HEAD" && Enum.member?(methods, "GET")
    Enum.member?(methods, req_method) || req_method == "OPTIONS" || head
  end
end
