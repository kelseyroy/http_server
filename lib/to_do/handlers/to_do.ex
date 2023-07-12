defmodule ToDo.Handlers.ToDo do
  alias HTTPServer.Request
  alias HTTPServer.Response.Body
  alias ToDo.API
  alias HTTPServer.Router.Handlers.NotFound
  @behaviour HTTPServer.Handler

  @impl HTTPServer.Handler
  def handle(%Request{method: "POST", body: body} = req) do
    decoded_body = Body.handle(body, :json)

    case API.create(decoded_body) do
      :ok -> {201, decoded_body, :json}
      {:error, _} -> NotFound.handle(req)
    end
  end
end
