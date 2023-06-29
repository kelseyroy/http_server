defmodule HTTPServerFixture.SimpleHead do
  alias HTTPServer.Request
  @behaviour HTTPServer.Handler

  @impl HTTPServer.Handler
  def handle(%Request{method: "GET"}) do
    body = "This body does not show up in a HEAD request"
    {200, body, :text}
  end
end
