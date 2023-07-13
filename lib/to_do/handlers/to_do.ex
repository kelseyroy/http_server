defmodule ToDo.Handlers.ToDo do
  alias HTTPServer.Request
  alias HTTPServer.Response.Body
  alias ToDo.API
  alias HTTPServer.Router.Handlers.NotFound
  @behaviour HTTPServer.Handler

  @impl HTTPServer.Handler
  def handle(%Request{method: "POST", body: body} = req) do
    {status, value} = Body.handle(body, :json)

    case API.create({status, value}) do
      :ok -> {201, value, :json}
      {:error, _} -> NotFound.handle(req)
    end
  end
end
