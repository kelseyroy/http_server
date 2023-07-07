defmodule HTTPServer.Router.Handlers.ServeStatic do
  alias HTTPServer.Request
  alias HTTPServer.Router.Handlers.NotFound
  @behaviour HTTPServer.Handler
  @routes Application.compile_env(:http_server, :routes, Routes)

  @impl HTTPServer.Handler
  def handle(req = %Request{path: path}) do
    filepath = @routes.routes[path][:filepath]

    case File.read(filepath) do
      {:ok, contents} -> get_media_type(filepath, contents, req)
      {:error, _} -> NotFound.handle(req)
    end
  end

  defp get_media_type(filepath, file_contents, req) do
    file_type = filepath |> String.split(".", trim: true) |> List.last()

    case file_type do
      "html" -> send_resp(:html, file_contents)
      "json" -> send_resp(:json, file_contents)
      "xml" -> send_resp(:xml, file_contents)
      "txt" -> send_resp(:text, file_contents)
      "css" -> send_resp(:css, file_contents)
      "png" -> send_resp(:png, file_contents)
      "gif" -> send_resp(:gif, file_contents)
      "jpg" -> send_resp(:jpeg, file_contents)
      _ -> NotFound.handle(req)
    end
  end

  defp send_resp(media_type, file_contents) do
    {200, file_contents, media_type}
  end
end
