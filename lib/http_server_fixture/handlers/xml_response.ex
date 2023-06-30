defmodule HTTPServerFixture.XMLResponse do
  alias HTTPServer.Request

  @behaviour HTTPServer.Handler

  @impl HTTPServer.Handler
  def handle(%Request{method: "GET"}) do
    body = "<note><body>XML Response</body></note>"
    {200, body, :xml}
  end
end
