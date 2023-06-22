defmodule HTTPServerFixture.SimplePost do
  alias HTTPServer.Request
  @behaviour HTTPServer.Handler

  @impl HTTPServer.Handler
  def handle(%Request{method: "POST"} = req) do
    {200, req.body}
  end
end
