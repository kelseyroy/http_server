defmodule HTTPServer.Request.Parser do
  alias HTTPServer.Request

  @carriage_return "\r\n"
  def parse(message) do
    [request_data, body] = message |> String.split("#{@carriage_return}#{@carriage_return}")
    [first | headers] = request_data |> String.split("#{@carriage_return}")
    headers = parse_headers(headers, %{})
    [method, path, resource] = first |> String.split(" ")
    params = parse_params(path)
    full_path = parse_path(path)

    %Request{
      method: method,
      full_path: full_path,
      route_path: List.first(full_path),
      resource: resource,
      headers: headers,
      body: body,
      params: params,
      id: parse_id_from_path(full_path)
    }
  end

  defp parse_headers([head | tail], headers) do
    [key, value] = head |> String.split(": ")
    headers = Map.put(headers, key, value)
    parse_headers(tail, headers)
  end

  defp parse_headers([], headers), do: headers

  defp parse_path(path) do
    [path | _query_string] = String.split(path, "?")
    split(path)
  end

  defp split(path) do
    for segment <- String.split(path, "/"), segment != "", do: "/#{segment}"
  end

  defp parse_params(path) do
    case String.split(path, "?") do
      [_] ->
        nil

      [_path, query_string] ->
        query_string
        |> String.split("&")
        |> Enum.reduce(%{}, &parse_param/2)
    end
  end

  defp parse_param(param_str, acc) do
    [param_name, param_value] = String.split(param_str, "=")
    Map.put(acc, param_name, param_value)
  end

  defp parse_id_from_path(path) do
    id_path = Enum.at(path, 1)

    case is_binary(id_path) do
      false ->
        ""

      true ->
        [_id, id] = id_path |> String.split("/")
        id
    end
  end
end
