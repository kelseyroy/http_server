defmodule HTTPServerTestFixture.MockRoutes do
  alias HTTPServer.Request
  alias HTTPServerTestFixture.Handlers.MockGet
  alias HTTPServerTestFixture.Handlers.MockPost

  def route(%Request{path: "/test_post"} = req), do: MockPost.handle(req)
  def route(%Request{path: "/test_get"} = req), do: MockGet.handle(req)
end
