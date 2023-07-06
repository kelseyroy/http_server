defmodule HTTPServerTest.ServeStatic do
  alias HTTPServer.Router.Handlers.ServeStatic
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
    assert ServeStatic.add_static_dir(%{}, path) == expected_routes
  end

  test "Adds more than one static directory for routes" do
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
    assert ServeStatic.add_static_dir(%{}, path, "/static") == expected_routes
  end
end
