defmodule HTTPServerTestFixture.Handlers.MockGet do
  alias HTTPServer.Request
  @behaviour HTTPServer.Handler
  @body "this is a mocked get with a body"

  @impl HTTPServer.Handler
  def handle(%Request{method: "GET"} = _req) do
    {200, @body}
  end
  def handle(%Request{method: "HEAD"} = _req) do
    {200, @body}
  end
  def handle(%Request{method: _method} = _req) do
    {404, ""}
  end
end
