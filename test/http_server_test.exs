defmodule HTTPServerTest do
  use ExUnit.Case
  doctest HTTPServer

  describe "parse/1" do
    #  TODO: expect an error here instead of trying to handle
    # test "returns an empty request when and empty message is given" do
    #   message = ""
    #   expected = %HTTPServer.Request{method: nil, resource: nil, headers: %{}, body: ""}

    #   assert HTTPServer.parse(message) == expected
    # end

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

      expected = %HTTPServer.Request{
        method: :post,
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

      assert HTTPServer.parse(message) == expected
    end
  end

  describe "build_response/1" do
    test "returns properly formatted successful HTTP response" do
      request_struct = %HTTPServer.Request{
        method: :post,
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

      expected = %HTTPServer.Response{
        status_code: 200,
        status_message: :ok,
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

      assert HTTPServer.build_response(request_struct) == expected
    end

    test "returns response as text" do
      response_struct = %HTTPServer.Response{
        status_code: 200,
        status_message: :ok,
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

      expected =
        "HTTP/1.1 200 OK\r\n" <>
          "Accept: */*\r\n" <>
          "Content-Length: 9\r\n" <>
          "Content-Type: text/plain\r\n" <>
          "Host: 127.0.0.1 4000\r\n" <>
          "User-Agent: ExampleBrowser/1.0\r\n" <>
          "\r\n" <>
          "some body"

      assert HTTPServer.text(response_struct) == expected
    end
  end
end
