defmodule HTTPServerFixture.Routes do
  alias HTTPServer.Request
  alias HTTPServerFixture.Handler

  def route(%Request{path: "/echo_body"} = req), do: Handler.SimplePost.handle(req)
  def route(%Request{path: "/simple_get"} = req), do: Handler.SimpleGet.handle(req)
  def route(%Request{path: "/simple_get_with_body"} = req), do: Handler.SimpleGetWithBody.handle(req)
end
