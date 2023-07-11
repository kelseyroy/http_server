defmodule HTTPServerTestFixture.MockRoutes do
  alias HTTPServer.ServeStatic

  def routes() do
    %{
      "/test_post" => %{
        handler: HTTPServerTestFixture.Handlers.MockPost,
        methods: ["POST"]
      },
      "/test_get" => %{
        handler: HTTPServerTestFixture.Handlers.MockGet,
        methods: ["GET"]
      },
      "/test_redirect" => %{
        handler: HTTPServer.Router.Handlers.Redirect,
        methods: ["GET"],
        location: "/test_get"
      },
      "/test_text" => %{
        handler: HTTPServerTestFixture.Handlers.MockText,
        methods: ["GET"]
      },
      "/test_html" => %{
        handler: HTTPServerTestFixture.Handlers.MockHTML,
        methods: ["GET"]
      },
      "/test_json" => %{
        handler: HTTPServerTestFixture.Handlers.MockJSON,
        methods: ["GET"]
      },
      "/test_xml" => %{
        handler: HTTPServerTestFixture.Handlers.MockXML,
        methods: ["GET"]
      },
      "/json_only" => %{
        handler: HTTPServerTestFixture.Handlers.MockJSONOnly,
        methods: ["POST"]
      }
    }
    |> ServeStatic.add_static_routes("lib/http_server_test_fixture/mock_public")
  end
end
