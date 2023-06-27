defmodule HTTPServer.Response.Headers do
  defstruct content_length: nil, content_type: nil, host: nil, location: nil, allow: nil

  @type t :: %__MODULE__{
          content_length: non_neg_integer(),
          content_type: String.t(),
          host: String.t(),
          location: String.t(),
          allow: list(String.t())
        }

  def collect_headers(headers) do
    for {k, v} <- Map.from_struct(headers), v != nil, into: %{}, do: {k, v}
  end

  def format_response_headers(headers) do
    for {n, v} <- headers,
        into: "",
        do: "#{format_header_name(n)}: #{v}\r\n"
  end

  defp format_header_name(header_name) do
    to_string(header_name)
    |> String.split("_")
    |> Enum.map(&String.capitalize/1)
    |> Enum.join("-")
  end
end
