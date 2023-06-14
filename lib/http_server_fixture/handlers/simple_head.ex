defmodule HTTPServerFixture.SimpleHead do
  alias HTTPServer.Request
  @behaviour HTTPServer.Handler

  @impl HTTPServer.Handler
  def handle(%Request{method: _method} = _req) do
    {404, ""}
  end
end
