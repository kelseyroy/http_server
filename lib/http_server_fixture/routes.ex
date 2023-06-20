defmodule HTTPServerFixture.Routes do
  alias HTTPServer.Request
  # alias HTTPServer.Handler
  alias HTTPServerFixture.SimpleGet
  alias HTTPServerFixture.SimpleGetWithBody
  alias HTTPServerFixture.SimplePost
  alias HTTPServerFixture.SimpleHead
  @behaviour HTTPServer.Routes

  @routes %{
    "/echo_body" => ["POST"],
    "/simple_get" => ["GET", "HEAD"],
    "/simple_get_with_body" => ["GET", "HEAD"],
    "/head_request" => ["GET", "HEAD"]
  }
  @impl HTTPServer.Routes
  def fetch_route(path) do
    Map.fetch(@routes, path)
  end

  @impl HTTPServer.Routes
  def route(%Request{path: "/echo_body"} = req), do: SimplePost.handle(req)
  def route(%Request{path: "/simple_get"} = req), do: SimpleGet.handle(req)
  def route(%Request{path: "/simple_get_with_body"} = req), do: SimpleGetWithBody.handle(req)
  def route(%Request{path: "/head_request"} = req), do: SimpleHead.handle(req)
end
