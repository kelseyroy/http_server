defmodule HTTPServer.Router do
  alias HTTPServer.Response

  def router(req, routes_fn) do
    {status_code, body} = routes_fn.(req)
    Response.send_resp(status_code, body)
  end
end
