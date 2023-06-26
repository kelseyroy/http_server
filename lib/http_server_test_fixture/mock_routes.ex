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
        handler: HTTPServer.Handlers.Redirect,
        methods: ["GET"],
        location: "/test_get"
      }
    }
end
