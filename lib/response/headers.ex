defmodule HTTPServer.Response.Headers do
  alias HTTPServer.Request

  defstruct content_length: nil,
            content_type: nil,
            host: nil,
            location: nil,
            allow: nil,
            link: nil

  import HTTPServer.Response.HeadersBuilder
  @routes Application.compile_env(:http_server, :routes, Routes)

  @type t :: %__MODULE__{
          content_length: non_neg_integer(),
          content_type: String.t(),
          host: String.t(),
          location: String.t(),
          allow: list(String.t()),
          link: String.t()
        }

  def build(
        %Request{method: "OPTIONS", path: path, headers: headers},
        _status_code,
        body,
        media_type
      ) do
    %__MODULE__{}
    |> content(media_type, body)
    |> host(headers)
    |> allow(@routes.routes[path][:methods])
  end

  def build(%Request{path: path, headers: headers}, 405, body, media_type) do
    %__MODULE__{}
    |> content(media_type, body)
    |> host(headers)
    |> allow(@routes.routes[path][:methods])
  end

  def build(%Request{path: path, headers: headers}, 301, body, media_type) do
    %__MODULE__{}
    |> content(media_type, body)
    |> host(headers)
    |> location(@routes.routes[path][:location])
  end

  def build(%Request{headers: headers}, _status_code, body, media_type) do
    %__MODULE__{}
    |> content(media_type, body)
    |> host(headers)
  end

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
