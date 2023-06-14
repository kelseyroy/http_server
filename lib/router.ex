defmodule HTTPServer.Router do
  alias HTTPServer.Response

  def router(routes_fn, req) do
    {status_code, body} = routes_fn.(req)
    Response.send_resp(status_code, body)
  end
end
