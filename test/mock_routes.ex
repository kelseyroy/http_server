defmodule HTTPServer.MockRoutes do
  alias HTTPServer.Request
  # alias HTTPServer.Handler
  alias HTTPServerFixture.SimpleGet
  alias HTTPServerFixture.SimpleGetWithBody
  alias HTTPServerFixture.SimplePost

  def route(%Request{path: "/post_test"} = req), do: SimplePost.handle(req)
  def route(%Request{path: "/get_test"} = req), do: SimpleGet.handle(req)
  def route(%Request{path: "/get_test_with_body"} = req), do: TestGetWithBody.handle(req)
end
