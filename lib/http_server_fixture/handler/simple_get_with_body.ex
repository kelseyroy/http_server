defmodule HTTPServerFixture.Handler.SimpleGetWithBody do
  alias HTTPServer.Request
  @behaviour HTTPServerFixture.Handler

  @impl HTTPServerFixture.Handler
  def handle(%Request{method: "GET"} = _req) do
    {200, "Hello world"}
  end

  def handle(%Request{method: _method} = _req) do
    {404, ""}
  end
end
