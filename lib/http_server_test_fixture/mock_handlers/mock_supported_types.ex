defmodule HTTPServerTestFixture.Handlers.MockSupportedTypes do
  alias HTTPServer.Request
  alias HTTPServer.Helpers.Validate
  alias HTTPServer.Router.Handlers.UnsupportedMediaType
  @behaviour HTTPServer.Handler

  @impl HTTPServer.Handler
  def handle(req = %Request{method: "POST", body: body}) do
    supported_types = ["application/json"]

    case Validate.is_type(req, supported_types) do
      true -> {200, body, :json}
      false -> UnsupportedMediaType.handle(req)
    end
  end
end
