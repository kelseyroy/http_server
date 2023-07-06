defmodule HTTPServerTest.Router do
  use ExUnit.Case
  alias HTTPServer.Router
  alias HTTPServer.Request
  alias HTTPServer.Response
  alias HTTPServer.Router.Handlers.ServeStatic

  doctest HTTPServer

  test "returns properly formatted successful response to POST request at /test_post" do
    request = %Request{
      method: "POST",
      path: "/test_post",
      resource: "HTTP/1.1",
      headers: %{
        "Accept" => "*/*",
        "Content-Length" => 9,
        "Content-Type" => "text/plain;charset=utf-8",
        "Host" => "0.0.0.0:4000",
        "User-Agent" => "ExampleBrowser/1.0"
      },
      body: "testing testing 123"
    }

    expected_response = %Response{
      status_code: 200,
      status_message: "OK",
      resource: "HTTP/1.1",
      headers: %{
        content_length: 19,
        content_type: "text/plain;charset=utf-8",
        host: "0.0.0.0:4000"
      },
      body: "testing testing 123"
    }

    assert Router.router(request) == expected_response
  end

  test "returns properly formatted successful response to GET request" do
    request = %Request{
      method: "GET",
      path: "/test_get",
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
        content_length: 32,
        content_type: "text/plain;charset=utf-8",
        host: "0.0.0.0:4000"
      },
      body: "this is a mocked get with a body"
    }

    assert Router.router(request) == expected_response
  end

  test "returns properly formatted successful response to HEAD request at /test_get" do
    request = %Request{
      method: "HEAD",
      path: "/test_get",
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
        content_length: 32,
        content_type: "text/plain;charset=utf-8",
        host: "0.0.0.0:4000"
      },
      body: ""
    }

    assert Router.router(request) == expected_response
  end

  test "returns a 404 Page Not Found when making a request to a path that doesn't exist" do
    request = %Request{
      method: "GET",
      path: "/test-not-found",
      resource: "HTTP/1.1",
      headers: %{
        "Accept" => "*/*",
        "Content-Length" => 9,
        "Content-Type" => "text/plain;charset=utf-8",
        "Host" => "0.0.0.0:4000",
        "User-Agent" => "ExampleBrowser/1.0"
      },
      body: ""
    }

    expected_response = %Response{
      status_code: 404,
      status_message: "NOT FOUND",
      resource: "HTTP/1.1",
      headers: %{
        content_length: 105,
        content_type: "text/plain;charset=utf-8",
        host: "0.0.0.0:4000"
      },
      body:
        "Something went wrong at /test-not-found. See the README for instructions on how to customize your routes!"
    }

    assert Router.router(request) == expected_response
  end

  test "returns properly formatted successful response to OPTIONS request at /test_get" do
    request = %Request{
      method: "OPTIONS",
      path: "/test_get",
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
        content_length: 0,
        content_type: "text/plain;charset=utf-8",
        host: "0.0.0.0:4000",
        allow: "GET, HEAD, OPTIONS"
      },
      body: ""
    }

    assert Router.router(request) == expected_response
  end

  test "returns 301 redirect response to GET request at /old_path" do
    request = %Request{
      method: "GET",
      path: "/test_redirect",
      resource: "HTTP/1.1",
      headers: %{
        "Accept" => "*/*",
        "Host" => "0.0.0.0:4000",
        "User-Agent" => "ExampleBrowser/1.0"
      },
      body: ""
    }

    expected_response = %Response{
      status_code: 301,
      status_message: "MOVED PERMANENTLY",
      resource: "HTTP/1.1",
      headers: %{
        content_length: 0,
        content_type: "text/plain;charset=utf-8",
        host: "0.0.0.0:4000",
        location: "http://0.0.0.0:4000/test_get"
      },
      body: ""
    }

    assert Router.router(request) == expected_response
  end

  test "returns 405 Method Not Found Response to GET request at /test_post" do
    request = %Request{
      method: "GET",
      path: "/test_post",
      resource: "HTTP/1.1",
      headers: %{
        "Accept" => "*/*",
        "Content-Length" => 9,
        "Content-Type" => "text/plain;charset=utf-8",
        "Host" => "0.0.0.0:4000",
        "User-Agent" => "ExampleBrowser/1.0"
      },
      body: "testing testing 123"
    }

    expected_response = %Response{
      status_code: 405,
      status_message: "METHOD NOT ALLOWED",
      resource: "HTTP/1.1",
      headers: %{
        content_length: 0,
        content_type: "text/plain;charset=utf-8",
        host: "0.0.0.0:4000",
        allow: "POST, OPTIONS"
      },
      body: ""
    }

    assert Router.router(request) == expected_response
  end

  test "returns {200, \"Hello world!\", :text} from hello_world.txt file" do
    expected_result = {200, "Hello world!\n", :text}

    request = %Request{
      method: "GET",
      path: "/hello-world.txt",
      resource: "HTTP/1.1",
      headers: %{
        "Accept" => "*/*",
        "Host" => "0.0.0.0:4000",
        "User-Agent" => "ExampleBrowser/1.0"
      },
      body: ""
    }

    assert ServeStatic.handle(request) == expected_result
  end

  test "returns properly formatted response from mock_html.html file" do
    request = %Request{
      method: "GET",
      path: "/mock-html.html",
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
        content_length: 109,
        content_type: "text/html;charset=utf-8",
        host: "0.0.0.0:4000"
      },
      body:
        "<!DOCTYPE html>\n<html>\n\n<head>\n    <title>Basic Web Page</title>\n</head>\n\n<body>Hello World!</body>\n\n</html>\n"
    }

    assert Router.router(request) == expected_response
  end
end
