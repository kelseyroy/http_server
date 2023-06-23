defmodule HTTPServerTest.Router do
  use ExUnit.Case
  alias HTTPServer.Router
  alias HTTPServer.Request
  alias HTTPServer.Response

  doctest HTTPServer

  test "returns properly formatted successful response to POST request at /test_post" do
    request = %Request{
      method: "POST",
      path: "/test_post",
      resource: "HTTP/1.1",
      headers: %{
        "Accept" => "*/*",
        "Content-Length" => "9",
        "Content-Type" => "text/plain",
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
        "Content-Length" => "19",
        "Content-Type" => "text/plain",
        "Host" => "0.0.0.0:4000"
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
        "Content-Length" => "32",
        "Content-Type" => "text/plain",
        "Host" => "0.0.0.0:4000"
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
        "Content-Length" => "32",
        "Content-Type" => "text/plain",
        "Host" => "0.0.0.0:4000"
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
        "Content-Length" => "9",
        "Content-Type" => "text/plain",
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
        "Content-Length" => "128",
        "Content-Type" => "text/plain",
        "Host" => "0.0.0.0:4000"
      },
      body:
        "The requested URL /test-not-found was not found on this server. See the README for instructions on how to customize your routes!"
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
        "Content-Length" => "0",
        "Content-Type" => "text/plain",
        "Host" => "0.0.0.0:4000",
        "Allow" => "GET, HEAD, OPTIONS"
      },
      body: ""
    }

    assert Router.router(request) == expected_response
  end
end
