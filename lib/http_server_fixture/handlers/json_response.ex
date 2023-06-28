defmodule HTTPServerFixture.JSONResponse do
  alias HTTPServer.Request

  @behaviour HTTPServer.Handler

  @impl HTTPServer.Handler
  def handle(%Request{method: "GET"}) do
    {:ok, body} = JSON.encode(key1: "value1", key2: "value2")

    {200, body, :json}
  end
end
