defmodule HTTPServerTestFixture.Handlers.MockXML do
  alias HTTPServer.Request

  @behaviour HTTPServer.Handler

  @impl HTTPServer.Handler
  def handle(%Request{method: "GET"}) do
    body = "<text><para>hello world</para></text>"
    {200, body, :xml}
  end
end
