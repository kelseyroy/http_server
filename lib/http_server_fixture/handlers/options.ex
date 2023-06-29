defmodule HTTPServerFixture.Options do
  alias HTTPServer.Request
  @behaviour HTTPServer.Handler

  @impl HTTPServer.Handler
  def handle(%Request{method: "GET"}) do
    body = ""
    {200, body, :text}
  end
end
