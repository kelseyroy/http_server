defmodule HTTPServer.ServeStatic do
  def add_static_routes(routes, dirpath, path \\ "") do
    dirpath
    |> get_filepaths()
    |> build_routes(dirpath, path)
    |> Map.merge(routes)
  end

  defp get_filepaths(dirpath), do: Path.wildcard(dirpath <> "/*.{json,html,css,xml,txt,css,jpg,gif,png}")

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
