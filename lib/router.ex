defmodule HTTPServer.Router do
  alias HTTPServer.Response
  alias HTTPServer.Request

  def route(%Request{method: "POST", path: "/echo_body"} = req) do
    Response.send_resp(200, req.body)
  end

  def route(%Request{method: "GET", path: "/simple_get"} = _req) do
    Response.send_resp(200)
  end

  def route(%Request{method: "GET", path: "/simple_get_with_body"} = _req) do
    Response.send_resp(200, "Hello world")
  end

  def route(%Request{path: _path} = req) do
    Response.send_resp(404, req.body)
  end
end
