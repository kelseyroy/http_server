defmodule HTTPServer.NotFound do
  alias HTTPServer.Request
  @behaviour HTTPServer.Handler

  @impl HTTPServer.Handler
  def handle(%Request{method: _method} = req) do
    {404, req.body}
  end
end
