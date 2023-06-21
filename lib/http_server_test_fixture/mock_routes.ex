defmodule HTTPServerTestFixture.MockRoutes do
  def routes,
    do: %{
      "/test_post" => HTTPServerTestFixture.Handlers.MockPost,
      "/test_get" => HTTPServerTestFixture.Handlers.MockGet
    }
end
