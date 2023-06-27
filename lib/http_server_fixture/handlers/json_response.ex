defmodule HTTPServerFixture.JSONResponse do
  alias HTTPServer.Request
  alias HTTPServer.Response.Headers
  import HTTPServer.Response.HeadersBuilder
  @behaviour HTTPServer.Handler

  @impl HTTPServer.Handler
  def handle(%Request{method: "GET"} = req) do
    body = "{ key1: value1, key2: value2 }"

    headers =
      %Headers{}
      |> content_length(body)
      |> content_type("application/json;charset=utf-8")
      |> host(req.headers)

    {200, body, headers}
  end
end
