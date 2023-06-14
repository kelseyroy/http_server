defmodule HTTPServerTest.Router do
  use ExUnit.Case
  alias HTTPServer.Router
  alias HTTPServer.Request
  alias HTTPServer.Response
  # doctest HTTPServer

  defmodule HttpRouterTest.MockRoutes do
    alias HTTPServer.Request
    alias HTTPServerFixture.SimpleGet
    alias HTTPServerFixture.TestGetWithBody
    alias HTTPServerFixture.SimplePost
    def route(%Request{path: "/post_test"} = req), do: SimplePost.handle(req)
    def route(%Request{path: "/get_test"} = req), do: SimpleGet.handle(req)

    def route(%Request{path: "/get_test_with_body"} = req),
      do: TestGetWithBody.handle(req)
  end

  describe "Router/2" do
    test "returns properly formatted successful response to GET request at /get_test" do
      mock_routes = &HttpRouterTest.MockRoutes.route/1

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
      mock_routes = &HttpRouterTest.MockRoutes.route/1

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
      mock_routes = &HttpRouterTest.MockRoutes.route/1

      request = %Request{
        method: "GET",
        path: "/get_test_with_body",
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
          "Content-Length" => "60",
          "Content-Type" => "text/plain",
          "Host" => "127.0.0.1:4000"
        },
        body: "Body-ody-ody-ody-ody-ody-ody-ody-ody-ody-ody-ody-ody-ody-ody"
      }

      assert Router.router(mock_routes, request) == expected_response
    end
  end
end
