defmodule HTTPServerTestFixture.Handlers.MockText do
  alias HTTPServer.Request
  @behaviour HTTPServer.Handler

  @impl HTTPServer.Handler
  def handle(%Request{method: "GET"}) do
    body = "hello world!"

    {200, body, :text}
  end
end
