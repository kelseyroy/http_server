defmodule HTTPServer.Request do
  defstruct method: "", path: "", resource: "", headers: %{}, body: ""

  @type t :: %__MODULE__{
          method: String.t(),
          path: String.t(),
          resource: String.t(),
          headers: %{optional(String.t()) => any},
          body: String.t()
        }

  @carriage_return "\r\n"

  def parse_request(message) do
    [request_data | body] = message |> String.split("#{@carriage_return}#{@carriage_return}")
    [first | headers] = request_data |> String.split("#{@carriage_return}")
    headers = parse_headers(headers, %{})
    [method, path, resource] = first |> String.split(" ")

    %__MODULE__{
      method: method,
      path: path,
      resource: resource,
      headers: headers,
      body: parse_body(hd(body), headers)
    }
  end

  defp parse_body(body, headers) do
    case headers["Content-Type"] do
      "application/json" ->
        {:ok, parsed_body} = JSON.decode(body)
        parsed_body

      _ ->
        body
    end
  end

  defp parse_headers([head | tail], headers) do
    [key, value] = head |> String.split(": ")
    headers = Map.put(headers, key, value)
    parse_headers(tail, headers)
  end

  defp parse_headers([], headers), do: headers
end
