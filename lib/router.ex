defmodule HTTPServer.Router do
  alias HTTPServer.Response
  alias HTTPServer.Request
  # defstruct method: "", path: "", resource: nil, headers: %{}, body: ""
  # @type method :: :get | :post | nil

  # sample request
  # request = """
  # GET /bigfoot HTTP/1.1
  # Host: example.com
  # User-Agent: ExampleBrowser/1.0
  # Accept: */*

  # """
  def route(%Request{method: :post, path: "/echo_body"} = req) do
    code = 200

    %Response{
      status_code: code,
      status_message: Response.status_message(code),
      resource: req.resource,
      headers: req.headers,
      body: req.body
    }
  end

  # def route(%Request{method: "GET", path: "/bigfoot"} = request) do
  #   %{request | status: 200, :resp_body => "hello world"}
  # end
  # def route(%Request{method: "POST", path: "/bigfoot"} = request) do
  #   %{request | status: 200, resp_body = "hello world"}
  # end
  def route(%Request{path: _path} = req) do
    code = 404

    %Response{
      status_code: code,
      status_message: Response.status_message(code),
      resource: req.resource,
      headers: req.headers,
      body: req.body
    }
  end

  # def build_response(req) do
  #   %Response{
  #     status_code: 200,
  #     status_message: :ok,
  #     resource: req.resource,
  #     headers: req.headers,
  #     body: req.body
  #   }
  # end
end
