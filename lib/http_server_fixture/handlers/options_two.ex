defmodule HTTPServerFixture.OptionsTwo do
  alias HTTPServer.Request
  @behaviour HTTPServer.Handler

  @impl HTTPServer.Handler
  def handle(%Request{method: "GET"} = _req) do
    {200, ""}
  end

  def handle(%Request{method: "PUT"} = req) do
    {200, req.body}
  end

  def handle(%Request{method: "POST"} = req) do
    {200, req.body}
  end

  def handle(%Request{method: _method} = _req) do
    {:error}
  end
end
