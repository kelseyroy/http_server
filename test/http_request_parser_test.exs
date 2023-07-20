defmodule HTTPServerTest.Request.Parser do
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
      full_path: ["/simple_get"],
      route_path: "/simple_get",
      resource: "HTTP/1.1",
      headers: %{
        "Accept" => "*/*",
        "Content-Length" => "9",
        "Content-Type" => "text/plain",
        "Host" => "0.0.0.0:4000",
        "User-Agent" => "ExampleBrowser/1.0"
      },
      body: "",
      params: nil
    }

    assert Request.Parser.parse(message) == expected_parsed_request
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
      full_path: ["/echo_body"],
      route_path: "/echo_body",
      resource: "HTTP/1.1",
      headers: %{
        "Accept" => "*/*",
        "Content-Length" => "9",
        "Content-Type" => "text/plain",
        "Host" => "0.0.0.0:4000",
        "User-Agent" => "ExampleBrowser/1.0"
      },
      body: "some body",
      params: nil
    }

    assert Request.Parser.parse(message) == expected_parsed_request
  end

  test "returns properly formatted path that seperates the path prefix and the subsequent slugs & params" do
    message =
      "GET /example/user_id?param1=value1&param2=value2&param3=value3 HTTP/1.1#{@carriage_return}" <>
        "Host: 0.0.0.0:4000#{@carriage_return}" <>
        "User-Agent: ExampleBrowser/1.0#{@carriage_return}" <>
        "Accept: */*#{@carriage_return}" <>
        "Content-Type: text/plain#{@carriage_return}" <>
        "Content-Length: 9#{@carriage_return}" <>
        "#{@carriage_return}" <>
        "some body"

    expected_parsed_request = %Request{
      method: "GET",
      full_path: ["/example", "/user_id"],
      route_path: "/example",
      params: %{"param1" => "value1", "param2" => "value2", "param3" => "value3"},
      resource: "HTTP/1.1",
      headers: %{
        "Accept" => "*/*",
        "Content-Length" => "9",
        "Content-Type" => "text/plain",
        "Host" => "0.0.0.0:4000",
        "User-Agent" => "ExampleBrowser/1.0"
      },
      body: "some body",
      id: "user_id"
    }

    assert Request.Parser.parse(message) == expected_parsed_request
  end
end
