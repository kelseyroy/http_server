defmodule HTTPServerFixture.OptionsTwo do
  alias HTTPServer.Request
  @behaviour HTTPServer.Handler

  @impl HTTPServer.Handler
  def handle(%Request{method: "GET"}) do
    body = ""
    {200, body, :text}
  end

  def handle(%Request{method: "PUT", body: body}) do
    body = body
    {200, body, :text}
  end

  def handle(%Request{method: "POST", body: body}) do
    body = body
    {200, body, :text}
  end
end
