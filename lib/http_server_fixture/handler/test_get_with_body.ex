defmodule HTTPServerFixture.TestGetWithBody do
  alias HTTPServer.Request
  @behaviour HTTPServer.Handler

  @impl HTTPServer.Handler
  def handle(%Request{method: "GET"} = _req) do
    {200, "Body-ody-ody-ody-ody-ody-ody-ody-ody-ody-ody-ody-ody-ody-ody"}
  end

  def handle(%Request{method: _method} = _req) do
    {404, ""}
  end
end
