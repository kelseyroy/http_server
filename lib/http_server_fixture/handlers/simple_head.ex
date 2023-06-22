defmodule HTTPServerFixture.SimpleHead do
  alias HTTPServer.Request
  @behaviour HTTPServer.Handler

  @impl HTTPServer.Handler
  def handle(%Request{method: "GET"} = _req) do
    {200, "This body does not show up in a HEAD request"}
  end

  def handle(%Request{method: _method} = _req) do
    {:error}
  end
end
