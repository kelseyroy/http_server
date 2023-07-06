defmodule HTTPServer.Router.Handlers.ServeStatic do
  alias HTTPServer.Request
  alias HTTPServer.Router.Handlers.NotFound
  require Logger
  @routes Application.compile_env(:http_server, :routes, Routes)

  def add_static_dir(routes, dirpath, path \\ "") do
    filepaths = Path.wildcard(dirpath <> "/**")

    Enum.map(filepaths, fn filepath ->
      file_name = String.replace(filepath, dirpath, "")
      new_path = path <> file_name

      new_route = %{
        handler: HTTPServer.Router.Handlers.ServeStatic,
        methods: ["GET"],
        filepath: filepath
      }

      {new_path, new_route}
    end)
    |> Map.new()
    |> Map.merge(routes)
  end

  def handle(req = %Request{path: path}) do
    filepath = @routes.routes[path][:filepath]

    case File.read(filepath) do
      {:ok, contents} -> {200, contents, get_media_type(filepath)}
      {:error, _} -> NotFound.handle(req)
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
