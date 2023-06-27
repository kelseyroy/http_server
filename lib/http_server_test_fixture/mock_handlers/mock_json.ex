defmodule HTTPServerTestFixture.Handlers.MockJSON do
  alias HTTPServer.Request
  alias HTTPServer.Response.Headers
  import HTTPServer.Response.HeadersBuilder
  @behaviour HTTPServer.Handler

  @impl HTTPServer.Handler
  def handle(%Request{method: "GET"} = req) do
    body = "{\"foo\": \"bar\"}"

    headers =
      %Headers{}
      |> content_length(body)
      |> content_type("application/json")
      |> host(req.headers)

    {200, body, headers}
  end
end
