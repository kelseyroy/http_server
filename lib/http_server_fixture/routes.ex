defmodule HTTPServerFixture.Routes do
  alias HTTPServer.Request
  # alias HTTPServer.Handler
  alias HTTPServerFixture.SimpleGet
  alias HTTPServerFixture.SimpleGetWithBody
  alias HTTPServerFixture.SimplePost

  def route(%Request{path: "/echo_body"} = req), do: SimplePost.handle(req)
  def route(%Request{path: "/simple_get"} = req), do: SimpleGet.handle(req)
  def route(%Request{path: "/simple_get_with_body"} = req), do: SimpleGetWithBody.handle(req)
end
