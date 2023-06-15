defmodule HTTPServerFixture.PageNotFound do
  @behaviour HTTPServer.Handler

  @impl HTTPServer.Handler
  def handle(req) do
    {404, "The requested URL #{req.path} was not found on this server. Sorry!"}
  end
end
