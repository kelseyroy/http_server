defmodule HTTPServer.Router do
  alias HTTPServer.Response

  def router(routes_fn, req) do

    case req.method do
      "HEAD" ->
        get_req = %{req | method: "GET"}
        {status_code, body} = routes_fn.(get_req)
        headers = Response.build_headers(body)
        Response.send_resp(status_code, "", headers)

      _ ->
        {status_code, body} = routes_fn.(req)
        headers = Response.build_headers(body)
        Response.send_resp(status_code, body, headers)
    end
  end
end
