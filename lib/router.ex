defmodule HTTPServer.Router do
  alias HTTPServer.Response

  def router(routes_fn, req) do
    {status_code, body} = routes_fn.(req)
    headers = Response.build_headers(body)

    case req.method do
      "HEAD" ->
        Response.send_resp(status_code, "", headers)

      _ ->
        Response.send_resp(status_code, body, headers)
    end
  end
end
