defmodule HTTPServer.Router.Handlers.ServeStatic do
  alias HTTPServer.Request
  alias HTTPServer.Router.Handlers.NotFound
  @behaviour HTTPServer.Handler
  @routes Application.compile_env(:http_server, :routes, Routes)

  @impl HTTPServer.Handler
  def handle(req = %Request{path: path}) do
    filepath = @routes.routes[path][:filepath]

    case File.read(filepath) do
      {:ok, contents} -> {200, contents, get_media_type(filepath)}
      {:error, _} -> NotFound.handle(req)
    end
  end

  def add_static_dir(routes, dirpath, path \\ "") do
    dirpath
    |> get_filepaths()
    |> build_routes(dirpath, path)
    |> Map.merge(routes)
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

  defp get_filepaths(dirpath), do: Path.wildcard(dirpath <> "/**")

  defp build_routes(filepaths, dirpath, path) do
    Enum.map(filepaths, fn filepath ->
      {path(path, filepath, dirpath), route(filepath)}
    end)
    |> Map.new()
  end

  defp path(path, filepath, dirpath), do: path <> filename(filepath, dirpath)

  defp filename(filepath, dirpath), do: String.replace(filepath, dirpath, "")

  defp route(filepath),
    do: %{
      handler: HTTPServer.Router.Handlers.ServeStatic,
      methods: ["GET"],
      filepath: filepath
    }
end
