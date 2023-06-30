defmodule HTTPServerTestFixture.Handlers.MockGet do
  alias HTTPServer.Request
  @behaviour HTTPServer.Handler

  @impl HTTPServer.Handler
  def handle(%Request{method: "GET"}) do
    body = "this is a mocked get with a body"
    {200, body, :text}
  end
end
