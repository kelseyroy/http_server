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

    expected_routes = %{
      "/test_path_one/hello-world.txt" => %{
        handler: HTTPServer.Router.Handlers.ServeStatic,
        methods: ["GET"],
        filepath: path1 <> "/hello-world.txt"
      },
      "/test_path_one/mock-html.html" => %{
        handler: HTTPServer.Router.Handlers.ServeStatic,
        methods: ["GET"],
        filepath: path1 <> "/mock-html.html"
      },
      "/test_path_one/mock-layout.css" => %{
        handler: HTTPServer.Router.Handlers.ServeStatic,
        methods: ["GET"],
        filepath: path1 <> "/mock-layout.css"
      },
      "/test_path_two/doggo.png" => %{
        handler: HTTPServer.Router.Handlers.ServeStatic,
        methods: ["GET"],
        filepath: path2 <> "/doggo.png"
      },
      "/test_path_two/health-check.html" => %{
        handler: HTTPServer.Router.Handlers.ServeStatic,
        methods: ["GET"],
        filepath: path2 <> "/health-check.html"
      },
      "/test_path_two/kisses.gif" => %{
        handler: HTTPServer.Router.Handlers.ServeStatic,
        methods: ["GET"],
        filepath: path2 <> "/kisses.gif"
      },
      "/test_path_two/kitteh.jpg" => %{
        handler: HTTPServer.Router.Handlers.ServeStatic,
        methods: ["GET"],
        filepath: path2 <> "/kitteh.jpg"
      },
      "/test_path_two/layout-styles.css" => %{
        handler: HTTPServer.Router.Handlers.ServeStatic,
        methods: ["GET"],
        filepath: path2 <> "/layout-styles.css"
      }
    }

    test_routes =
      Map.new()
      |> ServeStatic.add_static_routes(path1, "/test_path_one")
      |> ServeStatic.add_static_routes(path2, "/test_path_two")

    assert test_routes == expected_routes
  end
end
