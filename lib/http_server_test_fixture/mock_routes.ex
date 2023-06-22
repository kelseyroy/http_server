defmodule HTTPServerTestFixture.MockRoutes do
  def routes,
    do: %{
      "/test_post" => %{
        handler: HTTPServerTestFixture.Handlers.MockPost,
        methods: ["POST", "OPTIONS"]
      },
      "/test_get" => %{
        handler: HTTPServerTestFixture.Handlers.MockGet,
        methods: ["GET", "HEAD", "OPTIONS"]
      }
    }
end
