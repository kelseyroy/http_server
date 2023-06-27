defmodule HTTPServerFixture.TextResponse do
  alias HTTPServer.Request
  alias HTTPServer.Response.Headers
  import HTTPServer.Response.HeadersBuilder
  @behaviour HTTPServer.Handler

  @impl HTTPServer.Handler
  def handle(%Request{method: "GET"} = req) do
    body = "text response"

    headers =
      %Headers{}
      |> content_length(body)
      |> content_type("text/plain;charset=utf-8")
      |> host(req.headers)

    {200, body, headers}
  end
end
