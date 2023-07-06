defmodule HTTPServerTest.ServeStatic do
  alias HTTPServer.ServeStatic
  use ExUnit.Case
  doctest HTTPServer

  test "Creates routes on the root path using static files in mock_public" do
    path = "lib/http_server_test_fixture/mock_public"

    expected_routes = %{
      "/hello-world.txt" => %{
        handler: HTTPServer.Router.Handlers.ServeStatic,
        methods: ["GET"],
        filepath: path <> "/hello-world.txt"
      },
      "/mock-html.html" => %{
        handler: HTTPServer.Router.Handlers.ServeStatic,
        methods: ["GET"],
        filepath: path <> "/mock-html.html"
      },
      "/mock-layout.css" => %{
        handler: HTTPServer.Router.Handlers.ServeStatic,
        methods: ["GET"],
        filepath: path <> "/mock-layout.css"
      }
    }
    assert ServeStatic.static(%{}, path) == expected_routes
  end

  test "can customize route path for static routes" do
    path = "lib/http_server_test_fixture/mock_public"

    expected_routes = %{
      "/static/hello-world.txt" => %{
        handler: HTTPServer.Router.Handlers.ServeStatic,
        methods: ["GET"],
        filepath: path <> "/hello-world.txt"
      },
      "/static/mock-html.html" => %{
        handler: HTTPServer.Router.Handlers.ServeStatic,
        methods: ["GET"],
        filepath: path <> "/mock-html.html"
      },
      "/static/mock-layout.css" => %{
        handler: HTTPServer.Router.Handlers.ServeStatic,
        methods: ["GET"],
        filepath: path <> "/mock-layout.css"
      }
    }
    assert ServeStatic.static(%{}, path, "/static") == expected_routes
  end

  test "Returns an empty map when filepath is incorrect, which will default to 404 not found when routed" do
    path = "public"

    empty_map = Map.new()

    assert ServeStatic.static(%{}, path, "/static") == empty_map
  end
end
