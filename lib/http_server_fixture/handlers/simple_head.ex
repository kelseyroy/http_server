defmodule HTTPServerFixture.SimpleHead do
  alias HTTPServer.Request
  @behaviour HTTPServer.Handler
  @body "This body does not show up in a HEAD request"

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
