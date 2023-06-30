defmodule HTTPServerTestFixture.Handlers.MockHTMLFile do
  alias HTTPServer.Request
  @behaviour HTTPServer.Handler

  @impl HTTPServer.Handler
  def handle(%Request{method: "GET"}) do
    body =
      "<!DOCTYPE html><html><head><title>Basic Web Page</title></head><body>Hello World!</body></html>"

    {200, body, :html}
  end
end
