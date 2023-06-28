defmodule HTTPServerTestFixture.Handlers.MockPost do
  alias HTTPServer.Request
  @behaviour HTTPServer.Handler

  @impl HTTPServer.Handler
  def handle(%Request{method: "POST"} = req) do
    body = req.body
    {200, body, :text}
  end
end
