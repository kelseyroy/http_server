defmodule HTTPServerFixture.XMLResponse do
  alias HTTPServer.Request
  alias HTTPServer.Response.Headers
  import HTTPServer.Response.HeadersBuilder
  @behaviour HTTPServer.Handler

  @impl HTTPServer.Handler
  def handle(%Request{method: "GET"} = req) do
    body = "<note><body>XML Response</body></note>"

    headers =
      %Headers{}
      |> content_length(body)
      |> content_type("application/xml;charset=utf-8")
      |> host(req.headers)

    {200, body, headers}
  end
end
