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

  defp router(_req = %Request{method: "OPTIONS"}, handler) do
    methods = handler.methods
    headers = Response.build_options_headers(methods)
    Response.send_resp(200, "", headers)
  end

  # defp router(_req = %Request{method: "OPTIONS"}, handler) do
  #   methods = get_methods(handler)
  #   headers = Response.build_options_headers(methods)
  #   Response.send_resp(200, "", headers)
  # end

  defp router(req = %Request{method: "HEAD"}, handler) do
    {status_code, body} = handler.handle(%{req | method: "GET"})
    headers = Response.build_headers(body)
    Response.send_resp(status_code, "", headers)
  end

  defp router(req, handler) do
    {status_code, body} = handler.handle(req)
    headers = Response.build_headers(body)
    Response.send_resp(status_code, body, headers)
  end

  defp route_not_found(req) do
    {status_code, body} = NotFound.handle(req)
    headers = Response.build_headers(body)
    Response.send_resp(status_code, body, headers)
  end

  # defp get_methods(handler) do
  #   possible_methods = ["POST", "GET", "PUT", "PATCH", "DELETE"]

  #   methods =
  #     Enum.flat_map(possible_methods, fn method ->
  #       case handler.handle(%Request{method: method}) do
  #         {200, _body} -> [method]
  #         _ -> []
  #       end
  #     end)

  #   [methods | ["HEAD", "OPTIONS"]]
  # end
end
