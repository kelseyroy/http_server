defmodule HTTPServerFixture.SimpleGet do
  alias HTTPServer.Request
  alias HTTPServer.Response
  @behaviour HTTPServer.Handler

  @impl HTTPServer.Handler
  def handle(%Request{method: "GET"} = _req) do
    {200, "", Response.build_headers("")}
  end
end
