defmodule HTTPServerFixture.SimpleHead do
  alias HTTPServer.Request
  alias HTTPServer.Response
  @behaviour HTTPServer.Handler

  @impl HTTPServer.Handler
  def handle(%Request{method: "GET"} = _req) do
    body = "This body does not show up in a HEAD request"
    {200, body, Response.build_headers(body)}
  end
end
