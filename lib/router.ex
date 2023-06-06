defmodule HTTPServer.Router do
  alias HTTPServer.Response
  alias HTTPServer.Request

  def route(%Request{method: "POST", path: "/echo_body"} = req) do
    Response.build_response(req, 200)
  end

  def route(%Request{method: "GET", path: "/simple_get"} = req) do
    Response.build_response(req, 200)
  end

  def route(%Request{method: "GET", path: "/simple_get_with_body"} = req) do
    Response.build_response(req, 200)
  end

  def route(%Request{path: _path} = req) do
    Response.build_response(req, 404)
  end
end
