defmodule HTTPServerTestFixture.MockRoutes do
  def routes,
    do: %{
      "/test_post" => &HTTPServerTestFixture.Handlers.MockPost.handle/1,
      "/test_get" => &HTTPServerTestFixture.Handlers.MockGet.handle/1
    }
end
