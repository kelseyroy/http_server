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

    assert ServeStatic.add_static_routes(%{}, path) == expected_routes
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

    assert ServeStatic.add_static_routes(%{}, path, "/static") == expected_routes
  end

  test "Returns an empty map when filepath is incorrect, which will default to 404 not found when routed" do
    path = "not_a_real_dir"

    empty_map = Map.new()

    assert ServeStatic.add_static_routes(%{}, path, "/static") == empty_map
  end

  test "Can add multiple static directories to routes map" do
    path1 = "lib/http_server_test_fixture/mock_public"
    path2 = "test/http_server_spec/web"

    empty_map = Map.new()

    mock_public_static_map = ServeStatic.add_static_routes(empty_map, path1)

    expected_routes = %{
      "/hello-world.txt" => %{
        handler: HTTPServer.Router.Handlers.ServeStatic,
        methods: ["GET"],
        filepath: path1 <> "/hello-world.txt"
      },
      "/mock-html.html" => %{
        handler: HTTPServer.Router.Handlers.ServeStatic,
        methods: ["GET"],
        filepath: path1 <> "/mock-html.html"
      },
      "/mock-layout.css" => %{
        handler: HTTPServer.Router.Handlers.ServeStatic,
        methods: ["GET"],
        filepath: path1 <> "/mock-layout.css"
      },
      "/static/doggo.png" => %{
        handler: HTTPServer.Router.Handlers.ServeStatic,
        methods: ["GET"],
        filepath: path2 <> "/doggo.png"
      },
      "/static/health-check.html" => %{
        handler: HTTPServer.Router.Handlers.ServeStatic,
        methods: ["GET"],
        filepath: path2 <> "/health-check.html"
      },
      "/static/kisses.gif" => %{
        handler: HTTPServer.Router.Handlers.ServeStatic,
        methods: ["GET"],
        filepath: path2 <> "/kisses.gif"
      },
      "/static/kitteh.jpg" => %{
        handler: HTTPServer.Router.Handlers.ServeStatic,
        methods: ["GET"],
        filepath: path2 <> "/kitteh.jpg"
      },
      "/static/layout-styles.css" => %{
        handler: HTTPServer.Router.Handlers.ServeStatic,
        methods: ["GET"],
        filepath: path2 <> "/layout-styles.css"
      }
    }

    assert ServeStatic.add_static_routes(mock_public_static_map, path2, "/static") == expected_routes
  end
end
