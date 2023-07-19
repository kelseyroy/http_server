defmodule HTTPServer.Router do
  alias HTTPServer.Router.Handlers.MethodNotAllowed
  alias HTTPServer.Response
  alias HTTPServer.Request
  alias HTTPServer.Router.Handlers.NotFound
  alias HTTPServer.Router.Handlers.Options
  alias HTTPServer.Routes

  @routes Application.compile_env(:http_server, :routes, Routes)

  def router(req = %Request{route_path: path}) do
    case Map.fetch(@routes.routes, path) do
      {:ok, path_info} -> route_if_allowed(req, path_info)
      _ -> route_not_found(req)
    end
  end

  defp route_if_allowed(req = %Request{method: method}, path_info) do
    case is_method_allowed(method, path_info) do
      true -> router(req, path_info)
      false -> method_not_allowed(req)
    end
  end

  defp router(req = %Request{method: "OPTIONS"}, _path_info) do
    {status_code, body, media_type} = Options.handle(req)
    Response.build(req, status_code, body, media_type)
  end

  defp router(req = %Request{method: "HEAD"}, path_info) do
    {:ok, handler} = Map.fetch(path_info, :handler)
    {status_code, body, media_type} = handler.handle(%{req | method: "GET"})
    Response.build(req, status_code, body, media_type)
  end

  defp router(req, path_info) do
    {:ok, handler} = Map.fetch(path_info, :handler)
    {status_code, body, media_type} = handler.handle(req)
    Response.build(req, status_code, body, media_type)
  end

  defp route_not_found(req) do
    {status_code, body, media_type} = NotFound.handle(req)
    Response.build(req, status_code, body, media_type)
  end

  defp method_not_allowed(req) do
    {status_code, body, media_type} = MethodNotAllowed.handle(req)
    Response.build(req, status_code, body, media_type)
  end

  defp is_method_allowed(req_method, path_info) do
    {:ok, methods} = Map.fetch(path_info, :methods)
    is_method_in_methods = Enum.member?(methods, req_method)
    is_head_allowed = req_method == "HEAD" && Enum.member?(methods, "GET")
    is_options = req_method == "OPTIONS"

    is_options || is_method_in_methods || is_head_allowed
  end
end
