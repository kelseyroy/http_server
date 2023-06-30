defmodule HTTPServerTestFixture.MockRoutes do
  def routes,
    do: %{
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
      "/hello-world.text" => %{
        handler: HTTPServer.Router.Handlers.ServeStatic,
        methods: ["GET"],
        filepath: "lib/http_server_test_fixture/mock_public/hello-world.txt"
      },
      "/mock-html.html" => %{
        handler: HTTPServer.Router.Handlers.ServeStatic,
        methods: ["GET"],
        filepath: "lib/http_server_test_fixture/mock_public/mock-html.html",
        stylesheet: "/mock-layout.css"
      },
      "/mock-layout.css" => %{
        handler: HTTPServer.Router.Handlers.ServeStatic,
        methods: ["GET"],
        filepath: "lib/http_server_test_fixture/mock_public/mock-layout.css"
      }
    }
end
