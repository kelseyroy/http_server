defmodule HTTPServerTestFixture.Routes do
  alias HTTPServer.Request
  alias HTTPServerTestFixture.Handlers.GetWithBody

  alias HTTPServerFixture.SimpleGet
  alias HTTPServerFixture.SimplePost

  def route(%Request{path: "/post_test"} = req), do: SimplePost.handle(req)
  def route(%Request{path: "/get_test"} = req), do: SimpleGet.handle(req)

  def route(%Request{path: "/test_get_with_body"} = req),
    do: GetWithBody.handle(req)
end
