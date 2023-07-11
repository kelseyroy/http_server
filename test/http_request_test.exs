defmodule HTTPServerTest.Request do
  use ExUnit.Case
  alias HTTPServer.Request
  doctest HTTPServer

  @carriage_return "\r\n"

  test "returns properly formatted HTTP GET request without body" do
    message =
      "GET /simple_get HTTP/1.1#{@carriage_return}" <>
        "Host: 0.0.0.0:4000#{@carriage_return}" <>
        "User-Agent: ExampleBrowser/1.0#{@carriage_return}" <>
        "Accept: */*#{@carriage_return}" <>
        "Content-Type: text/plain#{@carriage_return}" <>
        "Content-Length: 9#{@carriage_return}" <>
        "#{@carriage_return}" <>
        ""

    expected_parsed_request = %Request{
      method: "GET",
      path: "/simple_get",
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

    assert Request.parse_request(message) == expected_parsed_request
  end

  test "returns properly formatted HTTP POST request" do
    message =
      "POST /echo_body HTTP/1.1#{@carriage_return}" <>
        "Host: 0.0.0.0:4000#{@carriage_return}" <>
        "User-Agent: ExampleBrowser/1.0#{@carriage_return}" <>
        "Accept: */*#{@carriage_return}" <>
        "Content-Type: text/plain#{@carriage_return}" <>
        "Content-Length: 9#{@carriage_return}" <>
        "#{@carriage_return}" <>
        "some body"

    expected_parsed_request = %Request{
      method: "POST",
      path: "/echo_body",
      resource: "HTTP/1.1",
      headers: %{
        "Accept" => "*/*",
        "Content-Length" => "9",
        "Content-Type" => "text/plain",
        "Host" => "0.0.0.0:4000",
        "User-Agent" => "ExampleBrowser/1.0"
      },
      body: "some body"
    }

    assert Request.parse_request(message) == expected_parsed_request
  end

  test "parses JSON request bodies" do
    json_body = "{\"foo\":\"bar\"}"

    req =
      "POST /json_body HTTP/1.1#{@carriage_return}" <>
        "Host: 0.0.0.0:4000#{@carriage_return}" <>
        "User-Agent: ExampleBrowser/1.0#{@carriage_return}" <>
        "Accept: */*#{@carriage_return}" <>
        "Content-Type: application/json#{@carriage_return}" <>
        "Content-Length: 9#{@carriage_return}" <>
        "#{@carriage_return}" <>
        json_body

    expected_parsed_request = %Request{
      method: "POST",
      path: "/json_body",
      resource: "HTTP/1.1",
      headers: %{
        "Accept" => "*/*",
        "Content-Length" => "9",
        "Content-Type" => "application/json",
        "Host" => "0.0.0.0:4000",
        "User-Agent" => "ExampleBrowser/1.0"
      },
      body: %{"foo" => "bar"}
    }

    assert Request.parse_request(req) == expected_parsed_request
  end
end
