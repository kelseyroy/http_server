defmodule HTTPServerTest do
  use ExUnit.Case
  alias HTTPServer.Response
  alias HTTPServer.Request
  alias HTTPServer.Router
  doctest HTTPServer

  describe "Request/1" do
    test "returns properly formatted HTTP GET request without body" do
      message =
        "GET /simple_get HTTP/1.1\r\n" <>
          "Host: 127.0.0.1 4000\r\n" <>
          "User-Agent: ExampleBrowser/1.0\r\n" <>
          "Accept: */*\r\n" <>
          "Content-Type: text/plain\r\n" <>
          "Content-Length: 9\r\n" <>
          "\r\n" <>
          ""

      expected_parsed_request = %Request{
        method: "GET",
        path: "/simple_get",
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

      assert Request.parse_request(message) == expected_parsed_request
    end

    test "returns properly formatted HTTP POST request" do
      message =
        "POST /echo_body HTTP/1.1\r\n" <>
          "Host: 127.0.0.1 4000\r\n" <>
          "User-Agent: ExampleBrowser/1.0\r\n" <>
          "Accept: */*\r\n" <>
          "Content-Type: text/plain\r\n" <>
          "Content-Length: 9\r\n" <>
          "\r\n" <>
          "some body"

      expected_parsed_request = %Request{
        method: "POST",
        path: "/echo_body",
        resource: "HTTP/1.1",
        headers: %{
          "Accept" => "*/*",
          "Content-Length" => "9",
          "Content-Type" => "text/plain",
          "Host" => "127.0.0.1 4000",
          "User-Agent" => "ExampleBrowser/1.0"
        },
        body: "some body"
      }

      assert Request.parse_request(message) == expected_parsed_request
    end
  end

  # describe "Router/1" do
  #   test "returns properly formatted successful response to POST request at /echo-body" do
  #     test_router = HTTPServer.Router
  #
  #     request = %Request{
  #       method: "POST",
  #       path: "/echo_body",
  #       resource: "HTTP/1.1",
  #       headers: %{
  #         "Accept" => "*/*",
  #         "Content-Length" => "9",
  #         "Content-Type" => "text/plain",
  #         "Host" => "127.0.0.1 4000",
  #         "User-Agent" => "ExampleBrowser/1.0"
  #       },
  #       body: "some body"
  #     }

  #     expected_response = %Response{
  #       status_code: 200,
  #       status_message: "OK",
  #       resource: "HTTP/1.1",
  #       headers: %{
  #         "Accept" => "*/*",
  #         "Content-Length" => "9",
  #         "Content-Type" => "text/plain",
  #         "Host" => "127.0.0.1 4000",
  #         "User-Agent" => "ExampleBrowser/1.0"
  #       },
  #       body: "some body"
  #     }

  #     assert Router.route(request) == expected_response
  #   end

  #   test "returns properly formatted 404 response to GET request at /echo-body" do
  #     request = %Request{
  #       method: "GET",
  #       path: "/echo_body",
  #       resource: "HTTP/1.1",
  #       headers: %{
  #         "Accept" => "*/*",
  #         "Content-Length" => "9",
  #         "Content-Type" => "text/plain",
  #         "Host" => "127.0.0.1 4000",
  #         "User-Agent" => "ExampleBrowser/1.0"
  #       },
  #       body: "some body"
  #     }

  #     expected_response = %Response{
  #       status_code: 404,
  #       status_message: "NOT FOUND",
  #       resource: "HTTP/1.1",
  #       headers: %{
  #         "Accept" => "*/*",
  #         "Content-Length" => "9",
  #         "Content-Type" => "text/plain",
  #         "Host" => "127.0.0.1 4000",
  #         "User-Agent" => "ExampleBrowser/1.0"
  #       },
  #       body: "some body"
  #     }

  #     assert Router.route(request) == expected_response
  #   end

  #   test "returns properly formatted successful response to GET request at /simple_get" do
  #     request = %Request{
  #       method: "GET",
  #       path: "/simple_get",
  #       resource: "HTTP/1.1",
  #       headers: %{
  #         "Accept" => "*/*",
  #         "Content-Length" => "0",
  #         "Content-Type" => "text/plain",
  #         "Host" => "127.0.0.1 4000",
  #         "User-Agent" => "ExampleBrowser/1.0"
  #       },
  #       body: ""
  #     }

  #     expected_response = %Response{
  #       status_code: 200,
  #       status_message: "OK",
  #       resource: "HTTP/1.1",
  #       headers: %{
  #         "Accept" => "*/*",
  #         "Content-Length" => "0",
  #         "Content-Type" => "text/plain",
  #         "Host" => "127.0.0.1 4000",
  #         "User-Agent" => "ExampleBrowser/1.0"
  #       },
  #       body: ""
  #     }

  #     assert Router.route(request) == expected_response
  #   end

  #   test "returns properly formatted successful response to GET request at /simple_get_with_body" do
  #     request = %Request{
  #       method: "GET",
  #       path: "/simple_get_with_body",
  #       resource: "HTTP/1.1",
  #       headers: %{
  #         "Accept" => "*/*",
  #         "Content-Length" => "0",
  #         "Content-Type" => "text/plain",
  #         "Host" => "127.0.0.1 4000",
  #         "User-Agent" => "ExampleBrowser/1.0"
  #       },
  #       body: ""
  #     }

  #     expected_response = %Response{
  #       status_code: 200,
  #       status_message: "OK",
  #       resource: "HTTP/1.1",
  #       headers: %{
  #         "Accept" => "*/*",
  #         "Content-Length" => "11",
  #         "Content-Type" => "text/plain",
  #         "Host" => "127.0.0.1 4000",
  #         "User-Agent" => "ExampleBrowser/1.0"
  #       },
  #       body: "Hello world"
  #     }

  #     assert Router.route(request) == expected_response
  #   end
  # end

  # describe "Response/1" do
  #   test "returns response as text with body" do
  #     response = %Response{
  #       status_code: 200,
  #       status_message: "OK",
  #       resource: "HTTP/1.1",
  #       headers: %{
  #         "Accept" => "*/*",
  #         "Content-Length" => "9",
  #         "Content-Type" => "text/plain",
  #         "Host" => "127.0.0.1 4000",
  #         "User-Agent" => "ExampleBrowser/1.0"
  #       },
  #       body: "some body"
  #     }

  #     expected_response_as_text =
  #       "HTTP/1.1 200 OK\r\n" <>
  #         "Accept: */*\r\n" <>
  #         "Content-Length: 9\r\n" <>
  #         "Content-Type: text/plain\r\n" <>
  #         "Host: 127.0.0.1 4000\r\n" <>
  #         "User-Agent: ExampleBrowser/1.0\r\n" <>
  #         "\r\n" <>
  #         "some body"

  #     assert Response.format_response(response) == expected_response_as_text
  #   end

  #   test "returns response without body" do
  #     response = %Response{
  #       status_code: 200,
  #       status_message: "OK",
  #       resource: "HTTP/1.1",
  #       headers: %{
  #         "Accept" => "*/*",
  #         "Content-Length" => "9",
  #         "Content-Type" => "text/plain",
  #         "Host" => "127.0.0.1 4000",
  #         "User-Agent" => "ExampleBrowser/1.0"
  #       },
  #       body: ""
  #     }

  #     expected_response_as_text =
  #       "HTTP/1.1 200 OK\r\n" <>
  #         "Accept: */*\r\n" <>
  #         "Content-Length: 9\r\n" <>
  #         "Content-Type: text/plain\r\n" <>
  #         "Host: 127.0.0.1 4000\r\n" <>
  #         "User-Agent: ExampleBrowser/1.0\r\n" <>
  #         "\r\n" <>
  #         ""

  #     assert Response.format_response(response) == expected_response_as_text
  #   end
  # end
end
