defmodule HTTPServer.Router.Handlers.ServeStatic do
  alias HTTPServer.Request
  alias HTTPServer.Router.Handlers.MethodNotAllowed
  @routes Application.compile_env(:http_server, :routes, Routes)

  def handle(req = %Request{path: path}) do
    filepath = @routes.routes[path][:filepath]

    case File.read(filepath) do
      {:ok, contents} -> {200, contents, get_media_type(filepath)}
      {:error, _} -> MethodNotAllowed.handle(req)
    end
  end

  defp get_media_type(filepath) do
    file_type = filepath |> String.split(".", trim: true) |> List.last()

    case file_type do
      "html" -> :html
      "json" -> :json
      "xml" -> :xml
      "txt" -> :text
      "css" -> :css
    end
  end
end
