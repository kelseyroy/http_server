defmodule HTTPServer.Request do
  defstruct method: "", path: "", resource: "", headers: %{}, body: ""

  @type t :: %__MODULE__{
    method: String.t(),
    path: String.t(),
    resource: String.t(),
    headers: %{optional(String.t()) => any},
    body: String.t()
  }

  def parse_request(message) do
    [request_data | body] = message |> String.split("\r\n\r\n")
    [first | headers] = request_data |> String.split("\r\n")
    [method, path, resource] = first |> String.split(" ")

    %__MODULE__{
      method: method,
      path: path,
      resource: resource,
      headers: parse_headers(headers, %{}),
      body: hd(body)
    }
  end

  defp parse_headers([head | tail], headers) do
    [key, value] = head |> String.split(": ")
    headers = Map.put(headers, key, value)
    parse_headers(tail, headers)
  end

  defp parse_headers([], headers), do: headers
end
