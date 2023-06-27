defmodule HTTPServerTestFixture.Handlers.MockHTML do
  alias HTTPServer.Request
  alias HTTPServer.Response.Headers
  import HTTPServer.Response.HeadersBuilder
  @behaviour HTTPServer.Handler

  @impl HTTPServer.Handler
  def handle(%Request{method: "GET"} = req) do
    body = "<!DOCTYPE html><html><head><title>Basic Web Page</title></head><body>Hello World!</body></html>"

    headers =
      %Headers{}
      |> content_length(body)
      |> content_type("text/html")
      |> host(req.headers)

    {200, body, headers}
  end
end
