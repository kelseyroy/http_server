defmodule HTTPServerTest.Router do
  use ExUnit.Case
  alias HTTPServer.Router
  alias HTTPServer.Request
  alias HTTPServer.Response
  alias HTTPServerTestFixture.MockRoutes

  doctest HTTPServer

  test "returns properly formatted successful response to POST request at /test_post" do
    mock_routes = &MockRoutes.route/1

    request = %Request{
      method: "POST",
      path: "/test_post",
      resource: "HTTP/1.1",
      headers: %{
        "Accept" => "*/*",
        "Content-Length" => "9",
        "Content-Type" => "text/plain",
        "Host" => "127.0.0.1 4000",
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
        "Host" => "127.0.0.1:4000"
      },
      body: "testing testing 123"
    }

    assert Router.router(mock_routes, request) == expected_response
  end

  test "returns properly formatted successful response to GET request" do
    mock_routes = &MockRoutes.route/1

    request = %Request{
      method: "GET",
      path: "/test_get",
      resource: "HTTP/1.1",
      headers: %{
        "Accept" => "*/*",
        "Host" => "127.0.0.1 4000",
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
        "Host" => "127.0.0.1:4000"
      },
      body: "this is a mocked get with a body"
    }

    assert Router.router(mock_routes, request) == expected_response
  end

  test "returns properly formatted successful response to HEAD request at /test_get" do
    mock_routes = &MockRoutes.route/1

    request = %Request{
      method: "HEAD",
      path: "/test_get",
      resource: "HTTP/1.1",
      headers: %{
        "Accept" => "*/*",
        "Host" => "127.0.0.1 4000",
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
        "Host" => "127.0.0.1:4000"
      },
      body: ""
    }

    assert Router.router(mock_routes, request) == expected_response
  end

  test "returns a 404 Page Not Found when making a request to a path that doesn't exist" do
    mock_routes = &MockRoutes.route/1

    request = %Request{
      method: "GET",
      path: "/test-not-found",
      resource: "HTTP/1.1",
      headers: %{
        "Accept" => "*/*",
        "Content-Length" => "9",
        "Content-Type" => "text/plain",
        "Host" => "127.0.0.1 4000",
        "User-Agent" => "ExampleBrowser/1.0"
      },
      body: ""
    }

    expected_response = %Response{
      status_code: 404,
      status_message: "NOT FOUND",
      resource: "HTTP/1.1",
      headers: %{
        "Content-Length" => "70",
        "Content-Type" => "text/plain",
        "Host" => "127.0.0.1:4000"
      },
      body: "The requested URL /test-not-found was not found on this server. Sorry!"
    }

    assert Router.router(mock_routes, request) == expected_response
  end
end
