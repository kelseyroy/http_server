defmodule HTTPServerTestFixture.Handlers.MockGet do
  alias HTTPServer.Request
  @behaviour HTTPServer.Handler
  def methods, do: ["GET", "HEAD", "OPTIONS"]
  @impl HTTPServer.Handler
  def handle(%Request{method: "GET"} = _req) do
    {200, "this is a mocked get with a body"}
  end
end
