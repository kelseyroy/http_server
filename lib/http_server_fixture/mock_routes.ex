defmodule HTTPServer.MockRoutes do
  alias HTTPServer.Request
  alias HTTPServerFixture.Handler

  def route(%Request{path: "/post_test"} = req), do: Handler.SimplePost.handle(req)
  def route(%Request{path: "/get_test"} = req), do: Handler.SimpleGet.handle(req)
  def route(%Request{path: "/get_test_with_body"} = req), do: Handler.TestGetWithBody.handle(req)
end
