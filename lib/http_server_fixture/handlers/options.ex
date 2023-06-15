defmodule HTTPServerFixture.Options do
  @behaviour HTTPServer.Handler

  @impl HTTPServer.Handler
  def handle(methods) do
    {200, methods}
  end
end
