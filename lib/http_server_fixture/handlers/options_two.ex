defmodule HTTPServerFixture.OptionsTwo do
  alias HTTPServer.Request
  @behaviour HTTPServer.Handler

  @impl HTTPServer.Handler
  def handle(%Request{method: "GET"} = _req) do
    body = ""
    {200, body, :text}
  end

  def handle(%Request{method: "PUT", body: body} = _req) do
    body = body
    {200, body, :text}
  end

  def handle(%Request{method: "POST", body: body} = _req) do
    body = body
    {200, body, :text}
  end
end
