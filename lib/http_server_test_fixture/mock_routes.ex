defmodule HTTPServerTestFixture.MockRoutes do
  alias HTTPServer.Request
  alias HTTPServerTestFixture.Handlers.MockGet
  alias HTTPServerTestFixture.Handlers.MockPost
  @behaviour HTTPServer.Routes

  @mock_routes %{
    "/test_post" => ["POST"],
    "/test_get" => ["GET", "HEAD"]
  }
  @impl HTTPServer.Routes
  def fetch_route(path) do
    Map.fetch(@mock_routes, path)
  end

  @impl HTTPServer.Routes
  def route(%Request{path: "/test_post"} = req), do: MockPost.handle(req)
  def route(%Request{path: "/test_get"} = req), do: MockGet.handle(req)
end
