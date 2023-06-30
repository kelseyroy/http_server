defmodule HTTPServerTestFixture.Handlers.MockJSON do
  alias HTTPServer.Request
  @behaviour HTTPServer.Handler

  @impl HTTPServer.Handler
  def handle(%Request{method: "GET"}) do
    body = [foo: "bar"]
    {200, body, :json}
  end
end
