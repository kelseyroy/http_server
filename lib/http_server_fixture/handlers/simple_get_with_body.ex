defmodule HTTPServerFixture.SimpleGetWithBody do
  alias HTTPServer.Request
  alias HTTPServer.Response
  @behaviour HTTPServer.Handler

  @impl HTTPServer.Handler
  def handle(%Request{method: "GET"} = _req) do
    body = "Hello world"
    {200, body, Response.build_headers(body)}
  end
end
