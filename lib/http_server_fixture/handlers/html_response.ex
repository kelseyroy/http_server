defmodule HTTPServerFixture.HTMLResponse do
  alias HTTPServer.Request
  alias HTTPServer.Response.Headers
  import HTTPServer.Response.HeadersBuilder
  @behaviour HTTPServer.Handler

  @impl HTTPServer.Handler
  def handle(%Request{method: "GET"} = req) do
    body = "<html><body><p>HTML Response</p></body></html>"

    headers =
      %Headers{}
      |> content_length(body)
      |> content_type("text/html;charset=utf-8")
      |> host(req.headers)

    {200, body, headers}
  end
end
