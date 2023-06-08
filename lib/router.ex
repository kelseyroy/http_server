defmodule HTTPServer.Router do
  alias HTTPServer.Response
  # alias HTTPServer.Request

  def router(req, routes) do
    {status_code, body} = routes.(req)
    Response.send_resp(status_code, body)
  end
  # def route(%Request{method: "POST", path: "/echo_body"} = req) do
  #   Response.send_resp(200, req.body)
  # end

  # def route(%Request{method: "GET", path: "/simple_get"} = _req) do
  #   Response.send_resp(200)
  # end

  # def route(%Request{method: "GET", path: "/simple_get_with_body"} = _req) do
  #   Response.send_resp(200, "Hello world")
  # end

  # def route(%Request{path: _path} = req) do
  #   Response.send_resp(404, req.body)
  # end
end


# Routings idea
#
# defmodule HTTPServer.Routes do
# alias HTTPServer.Requst
# alias HTTPServerFixture.Handler
#
# def handle(%Request{method: "POST", path: "/echo_body"} = req), do: Handler.SimplePost
# def handle(%Request{path: "/simple_get"} = req), do: Handler.SimpleGet(req)
# def handle(%Request{method: "POST", path: "/simple_get"} = req), do: Handler.SimpleGet
# def handle(%Request{method: "GET", path: "/simple_get_with_body"} = req), do: Handler.SimpleGetWithBody
# end

# def HTTPServer.

# def HTTPServerFixture.Handler.SimpleGet do
# @behavior HTTPServer.Handler
#
# @impl HTTPServer.Handler
# def handle(%Request{method: "POST} = request) do
# # do post things
# end
# def handle(%Request{method: "GET"} = request) do
# # do GET things
# end
# end
