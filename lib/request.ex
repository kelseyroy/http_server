defmodule HTTPServer.Request do
  defstruct method: "", full_path: [], route_path: "", resource: "", headers: %{}, body: "", params: %{}

  @type t :: %__MODULE__{
          method: String.t(),
          full_path: list(String.t()),
          route_path: String.t(),
          resource: String.t(),
          headers: %{optional(String.t()) => any},
          body: String.t(),
          params: %{optional(String.t()) => String.t()}
        }

  @carriage_return "\r\n"

  def parse_request(message) do
    [request_data, body] = message |> String.split("#{@carriage_return}#{@carriage_return}")
    [first | headers] = request_data |> String.split("#{@carriage_return}")
    headers = parse_headers(headers, %{})
    [method, path, resource] = first |> String.split(" ")
    params = parse_params(path)

    %__MODULE__{
      method: method,
      full_path: parse_path(path),
      route_path: List.first(parse_path(path)),
      resource: resource,
      headers: headers,
      body: body,
      params: params
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
      [_] -> nil
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
end
