defmodule HTTPServerFixture.HTMLResponse do
  alias HTTPServer.Request
  @behaviour HTTPServer.Handler

  @impl HTTPServer.Handler
  def handle(%Request{method: "GET"}) do
    body = "<html><body><p>HTML Response</p></body></html>"
    {200, body, :html}
  end
end
