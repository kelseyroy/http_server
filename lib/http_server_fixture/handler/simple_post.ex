defmodule HTTPServerFixture.Handler.SimplePost do
  alias HTTPServer.Request
  @behaviour HTTPServerFixture.Handler

  @impl HTTPServerFixture.Handler
  def handle(%Request{method: "POST"} = req) do
    {200, req.body}
  end
  def handle(%Request{method: _method} = _req) do
    {404, ""}
  end
end
