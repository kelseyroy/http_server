defmodule HTTPServer.Router do
  alias HTTPServer.Response

  def router(req, routes) do
    {status_code, body} = routes.(req)
    Response.send_resp(status_code, body)
  end
end
