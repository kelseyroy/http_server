defmodule HTTPServerFixture.SimpleGetWithBody do
  alias HTTPServer.Request
  @behaviour HTTPServer.Handler

  @impl HTTPServer.Handler
  def handle(%Request{method: "GET"}) do
    body = "Hello world"
    {200, body, :text}
  end
end
