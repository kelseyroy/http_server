defmodule HTTPServerTest.Response do
  use ExUnit.Case
  alias HTTPServer.Router
  alias HTTPServer.Request
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
        "Host: 0.0.0.0:4000#{@carriage_return}" <>
        "Content-Length: 15#{@carriage_return}" <>
        "Content-Type: text/plain;charset=utf-8#{@carriage_return}" <>
        "#{@carriage_return}" <>
        "this is my body"

    assert Response.format_response(response_object) == expected_parsed_response
  end

  test "a GET request to /test_text should return a text body" do
    request = %Request{
      method: "GET",
      path: "/test_text",
      resource: "HTTP/1.1",
      headers: %{
        "Accept" => "*/*",
        "Host" => "0.0.0.0:4000",
        "User-Agent" => "ExampleBrowser/1.0"
      },
      body: ""
    }

    expected_response = %Response{
      status_code: 200,
      status_message: "OK",
      resource: "HTTP/1.1",
      headers: %{
        content_length: 12,
        content_type: "text/plain;charset=utf-8",
        host: "0.0.0.0:4000"
      },
      body: "hello world!"
    }

    assert Router.router(request) == expected_response
  end

  test "a GET request to /test_html should return a html body" do
    request = %Request{
      method: "GET",
      path: "/test_html",
      resource: "HTTP/1.1",
      headers: %{
        "Accept" => "*/*",
        "Host" => "0.0.0.0:4000",
        "User-Agent" => "ExampleBrowser/1.0"
      },
      body: ""
    }

    expected_response = %Response{
      status_code: 200,
      status_message: "OK",
      resource: "HTTP/1.1",
      headers: %{
        content_length: 95,
        content_type: "text/html;charset=utf-8",
        host: "0.0.0.0:4000"
      },
      body:
        "<!DOCTYPE html><html><head><title>Basic Web Page</title></head><body>Hello World!</body></html>"
    }

    assert Router.router(request) == expected_response
  end

  test "a GET request to /test_xml should return a XML body" do
    request = %Request{
      method: "GET",
      path: "/test_xml",
      resource: "HTTP/1.1",
      headers: %{
        "Accept" => "*/*",
        "Host" => "0.0.0.0:4000",
        "User-Agent" => "ExampleBrowser/1.0"
      },
      body: ""
    }

    expected_response = %Response{
      status_code: 200,
      status_message: "OK",
      resource: "HTTP/1.1",
      headers: %{
        content_length: 37,
        content_type: "application/xml;charset=utf-8",
        host: "0.0.0.0:4000"
      },
      body: "<text><para>hello world</para></text>"
    }

    assert Router.router(request) == expected_response
  end

  test "a GET request to /test_json should return a json body" do
    request = %Request{
      method: "GET",
      path: "/test_json",
      resource: "HTTP/1.1",
      headers: %{
        "Accept" => "*/*",
        "Host" => "0.0.0.0:4000",
        "User-Agent" => "ExampleBrowser/1.0"
      },
      body: ""
    }

    {:ok, body} = JSON.encode(foo: "bar")

    expected_response = %Response{
      status_code: 200,
      status_message: "OK",
      resource: "HTTP/1.1",
      headers: %{
        content_length: byte_size(body),
        content_type: "application/json;charset=utf-8",
        host: "0.0.0.0:4000"
      },
      body: body
    }

    assert Router.router(request) == expected_response
  end

  test "Response.Body.handle/1 should return a 200 status response and decoded json body" do
    request = %Request{
      method: "POST",
      path: "/",
      resource: "HTTP/1.1",
      headers: %{
        "Accept" => "*/*",
        "Host" => "0.0.0.0:4000",
        "Content-Type" => "application/json",
        "User-Agent" => "ExampleBrowser/1.0"
      },
      body: JSON.encode!(key: "value")
    }

    assert Response.Body.handle(request, :json) == {:ok, %{"key" => "value"}}
  end

  test "Response.Body.handle/1 should return a 415 status response when Content-Type is not json" do
    request = %Request{
      method: "POST",
      path: "/",
      resource: "HTTP/1.1",
      headers: %{
        "Accept" => "*/*",
        "Host" => "0.0.0.0:4000",
        "Content-Type" => "text/html",
        "User-Agent" => "ExampleBrowser/1.0"
      },
      body: "<type>Not a valid type</type>"
    }

    unsupported_media_type_res = {415, "Unsupported Media Type", :text}

    assert Response.Body.handle(request, :json) == {:error, unsupported_media_type_res}
  end
end
