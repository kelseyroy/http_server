defmodule HTTPServerFixture.OptionsTwo do
  alias HTTPServer.Request
  alias HTTPServer.Response
  import HTTPServer.Response.HeadersBuilder
  @behaviour HTTPServer.Handler

  @impl HTTPServer.Handler
  def handle(%Request{method: "GET"} = req) do
    body = ""

    headers =
      Response.build_headers()
      |> content_length(body)
      |> content_type()
      |> host(req.headers)

    {200, body, headers}
  end

  def handle(%Request{method: "PUT"} = req) do
    body = req.body

    headers =
      Response.build_headers()
      |> content_length(body)
      |> content_type()
      |> host(req.headers)

    {200, body, headers}
  end

  def handle(%Request{method: "POST"} = req) do
    body = req.body

    headers =
      Response.build_headers()
      |> content_length(body)
      |> content_type()
      |> host(req.headers)

    {200, body, headers}
  end
end
