defmodule HTTPServerTest.Router do
  use ExUnit.Case
  alias HTTPServer.Router
  alias HTTPServer.Request
  alias HTTPServer.Response
  alias HTTPServerTestFixture.Routes

  # doctest HTTPServer

  describe "Router/2" do
    test "returns properly formatted successful response to GET request at /get_test" do
      # mock_routes = &HttpRouterTest.MockRoutes.route/1
      mock_routes = &Routes.route/1

      request = %Request{
        method: "GET",
        path: "/get_test",
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
          "Content-Length" => "0",
          "Content-Type" => "text/plain",
          "Host" => "127.0.0.1:4000"
        },
        body: ""
      }

      assert Router.router(mock_routes, request) == expected_response
    end

    test "returns properly formatted successful response to POST request at /post_test" do
      mock_routes = &Routes.route/1

      request = %Request{
        method: "POST",
        path: "/post_test",
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

    test "returns properly formatted successful response to GET request at /get_test_with_body" do
      mock_routes = &Routes.route/1

      request = %Request{
        method: "GET",
        path: "/test_get_with_body",
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
  end
end
