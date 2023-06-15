defmodule HTTPServer.Router do
  alias HTTPServer.Response
  alias HTTPServer.Request
  alias HTTPServer.Handlers.NotFound
  alias HTTPServer.Routes.ClientRoutes

  @routes Application.compile_env(:http_server, :routes, ClientRoutes)

  def router(req) do
    case Map.fetch(@routes.routes, req.path) do
      {:ok, handler} ->
        router(req, handler)

      _ ->
        route_not_found(req)
    end
  end

  defp router(req = %Request{method: "OPTIONS"}, handler) do
    {status_code, body} = handler.(%{req | method: "GET"})
    headers = Response.build_headers(body)
    Response.send_resp(status_code, "", headers)
  end

  defp router(req = %Request{method: "HEAD"}, handler) do
    {status_code, body} = handler.(%{req | method: "GET"})
    headers = Response.build_headers(body)
    Response.send_resp(status_code, "", headers)
  end

  defp router(req, handler) do
    {status_code, body} = handler.(req)
    headers = Response.build_headers(body)
    Response.send_resp(status_code, body, headers)
  end

  defp route_not_found(req) do
    {status_code, body} = NotFound.handle(req)
    headers = Response.build_headers(body)
    Response.send_resp(status_code, body, headers)
  end
end
