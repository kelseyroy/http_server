defmodule HTTPServerFixture.SimplePost do
  alias HTTPServer.Request
  alias HTTPServer.Response
  @behaviour HTTPServer.Handler

  @impl HTTPServer.Handler
  def handle(%Request{method: "POST"} = req) do
    body = req.body
    {200, body, Response.build_headers(body)}
  end
end
