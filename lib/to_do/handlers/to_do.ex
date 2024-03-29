defmodule ToDo.Handlers.ToDo do
  alias HTTPServer.Request
  alias HTTPServer.Response.Body
  alias ToDo.API
  alias HTTPServer.Router.Handlers.NotFound
  @behaviour HTTPServer.Handler

  @impl HTTPServer.Handler
  def handle(%Request{method: "POST"} = req) do
    {status, value} = Body.handle(req, :json)

    {status, value}
    |> API.create()
    |> case do
      :ok -> {201, value, :json}
      {:error, _} -> NotFound.handle(req)
      _ -> value
    end
  end

  def handle(%Request{method: "DELETE", id: id}) do
    API.delete(id)
    {204, "", :text}
  end

  def handle(%Request{method: "PUT", id: id} = req) do
    {status, value} = Body.handle(req, :json)

    {status, value}
    |> API.update(id)
    |> case do
      :ok -> {200, value, :json}
      {:error, _} -> NotFound.handle(req)
      _ -> value
    end
  end
end
