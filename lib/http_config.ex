defmodule HTTPServer.HTTPConfig do
  alias HTTPServer.Routes
  def determine_routes do
    env = Mix.env()

    case env do
      :test -> &HTTPServerTestFixture.MockRoutes.route/1
      :integration_test -> &HTTPServerFixture.Routes.route/1
      _ -> &Routes.route/1
    end
  end
end
