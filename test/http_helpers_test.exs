defmodule HTTPServerTest.Helpers do
  use ExUnit.Case
  alias HTTPServer.Helpers
  alias HTTPServer.Request
  doctest HTTPServer

  test "Validate.is_type/2 returns false if content-type is not specified in req" do
    supported_types = ["application/json"]

    req = %Request{
      method: "POST",
      path: "/json_body",
      resource: "HTTP/1.1",
      headers: %{
        "Accept" => "*/*",
        "Content-Length" => "14",
        "Host" => "0.0.0.0:4000",
        "User-Agent" => "ExampleBrowser/1.0"
      },
      body: "this should fail"
    }

    refute Helpers.Validate.is_type(req, supported_types)
  end

  test "Validate.is_type/2 returns false if content-type is not a supported type" do
    supported_types = ["application/json"]

    req = %Request{
      method: "POST",
      path: "/json_body",
      resource: "HTTP/1.1",
      headers: %{
        "Accept" => "*/*",
        "Content-Length" => "14",
        "Content-Type" => "text/html",
        "Host" => "0.0.0.0:4000",
        "User-Agent" => "ExampleBrowser/1.0"
      },
      body: "<type>Not a valid type</type>"
    }

    refute Helpers.Validate.is_type(req, supported_types)
  end

  test "Validate.is_type/2 returns true if content-type is a supported type" do
    supported_types = ["text/plain"]

    req = %Request{
      method: "PUT",
      path: "/json_body",
      resource: "HTTP/1.1",
      headers: %{
        "Accept" => "*/*",
        "Content-Length" => "39",
        "Content-Type" => "text/plain;charset=utf-8",
        "Host" => "0.0.0.0:4000",
        "User-Agent" => "ExampleBrowser/1.0"
      },
      body: "This content-type has extra parameters!"
    }

    assert Helpers.Validate.is_type(req, supported_types)
  end
end
