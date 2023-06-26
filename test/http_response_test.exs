defmodule HTTPServerTest.Response do
  use ExUnit.Case
  alias HTTPServer.Response.Headers
  alias HTTPServer.Response
  doctest HTTPServer

  @carriage_return "\r\n"

  test "returns a properly formatted 200 Response object when given {status_code, body, headers}" do
    status_code = 200
    body = "this is my body"

    headers = %Headers{
      content_length: "15",
      content_type: "text/plain",
      host: "0.0.0.0:4000"
    }

    expected_parsed_response = %Response{
      status_code: 200,
      status_message: "OK",
      resource: "HTTP/1.1",
      headers: %{
        content_length: "15",
        content_type: "text/plain",
        host: "0.0.0.0:4000"
      },
      body: "this is my body"
    }

    assert Response.send_resp(status_code, body, headers) == expected_parsed_response
  end

  test "returns properly formatted 404 response as a string" do
    response_object = %Response{
      status_code: 200,
      status_message: "OK",
      resource: "HTTP/1.1",
      headers: %{
        content_length: "15",
        content_type: "text/plain",
        host: "0.0.0.0:4000"
      },
      body: "this is my body"
    }

    expected_parsed_response =
      "HTTP/1.1 200 OK#{@carriage_return}" <>
        "Content-length: 15#{@carriage_return}" <>
        "Content-type: text/plain#{@carriage_return}" <>
        "Host: 0.0.0.0:4000#{@carriage_return}" <>
        "#{@carriage_return}" <>
        "this is my body"

    assert Response.format_response(response_object) == expected_parsed_response
  end
end
