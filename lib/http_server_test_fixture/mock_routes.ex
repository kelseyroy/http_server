defmodule HTTPServerTestFixture.MockRoutes do
  alias HTTPServer.Request
  alias HTTPServerTestFixture.Handlers.MockGet
  alias HTTPServerTestFixture.Handlers.MockPost
  alias HTTPServer.Handlers.NotFound

  def route(%Request{path: "/test_post"} = req), do: MockPost.handle(req)
  def route(%Request{path: "/test_get"} = req), do: MockGet.handle(req)
  def route(%Request{path: _path} = req), do: NotFound.handle(req)
end
