defmodule HTTPServerFixture.TextResponse do
  alias HTTPServer.Request
  @behaviour HTTPServer.Handler

  @impl HTTPServer.Handler
  def handle(%Request{method: "GET"}) do
    body = "text response"
    {200, body, :text}
  end
end
