defmodule HTTPServerTest.Response do
  use ExUnit.Case
  alias HTTPServer.Response
  alias HTTPServer.Request
  doctest HTTPServer

  @carriage_return "\r\n"

  test "returns a properly formatted 200 Response object when given {request, status_code, body, media_type}" do
    status_code = 200
    body = "this is my body"
    media_type = :text

    request = %Request{
      method: "GET",
      path: "/simple_get",
      resource: "HTTP/1.1",
      headers: %{
        "Accept" => "*/*",
        "Content-Length" => "0",
        "Content-Type" => "text/plain;charset=utf-8",
        "Host" => "0.0.0.0:4000",
        "User-Agent" => "ExampleBrowser/1.0"
      },
      body: ""
    }

    expected_parsed_response = %Response{
      status_code: 200,
      status_message: "OK",
      resource: "HTTP/1.1",
      headers: %{
        content_length: 15,
        content_type: "text/plain;charset=utf-8",
        host: "0.0.0.0:4000"
      },
      body: "this is my body"
    }

    assert Response.build(request, status_code, body, media_type) == expected_parsed_response
  end

  test "returns properly formatted response as a string" do
    response_object = %Response{
      status_code: 200,
      status_message: "OK",
      resource: "HTTP/1.1",
      headers: %{
        content_length: "15",
        content_type: "text/plain;charset=utf-8",
        host: "0.0.0.0:4000"
      },
      body: "this is my body"
    }

    expected_parsed_response =
      "HTTP/1.1 200 OK#{@carriage_return}" <>
        "Content-Length: 15#{@carriage_return}" <>
        "Content-Type: text/plain;charset=utf-8#{@carriage_return}" <>
        "Host: 0.0.0.0:4000#{@carriage_return}" <>
        "#{@carriage_return}" <>
        "this is my body"

    assert Response.format_response(response_object) == expected_parsed_response
  end
end
