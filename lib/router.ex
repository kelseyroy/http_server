defmodule HTTPServer.Router do
  alias HTTPServer.Response
  alias HTTPServer.Handlers.NotFound
  alias HTTPServer.Routes.ClientRoutes

  @routes Application.compile_env(:http_server, :routes, ClientRoutes)

  def router(req) do
    with {:ok, _methods} <- @routes.fetch_route(req.path),
         "HEAD" <- req.method do
      {status_code, body} = @routes.route(%{req | method: "GET"})
      headers = Response.build_headers(body)
      Response.send_resp(status_code, "", headers)
    else
      :error ->
        {status_code, body} = NotFound.handle(req)
        headers = Response.build_headers(body)
        Response.send_resp(status_code, body, headers)

      _ ->
        {status_code, body} = @routes.route(req)
        headers = Response.build_headers(body)
        Response.send_resp(status_code, body, headers)
    end
  end
end
