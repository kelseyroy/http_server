defmodule HTTPServerTestFixture.Handlers.MockGet do
  alias HTTPServer.Request
  alias HTTPServer.Response
  @behaviour HTTPServer.Handler

  @impl HTTPServer.Handler
  def handle(%Request{method: "GET"} = _req) do
    body = "this is a mocked get with a body"
    {200, body, Response.build_headers(body)}
  end
end
