defmodule HTTPServer.Response.Headers do
  alias HTTPServer.Request
  alias HTTPServer.Response
  defstruct content_length: nil, content_type: nil, host: nil, location: nil, allow: nil
  import HTTPServer.Response.HeadersBuilder
  @routes Application.compile_env(:http_server, :routes, Routes)

  @type t :: %__MODULE__{
          content_length: non_neg_integer(),
          content_type: String.t(),
          host: String.t(),
          location: String.t(),
          allow: list(String.t())
        }

  def new() do
    %__MODULE__{}
  end

  def build(
        res = %Response{headers: headers, body: body},
        _req = %Request{method: "OPTIONS", path: path, headers: headers},
        media_type
      ) do
    options_headers =
      headers
      |> content(media_type, body)
      |> host(headers)
      |> allow(@routes.routes[path][:methods])

    %{res | headers: options_headers}
  end

  def build(
        res = %Response{headers: headers, body: body, status_code: 405},
        _req = %Request{path: path, headers: headers},
        media_type
      ) do
    allowed_methods_headers =
      headers
      |> content(media_type, body)
      |> host(headers)
      |> allow(@routes.routes[path][:methods])

    %{res | headers: allowed_methods_headers}
  end

  def build(
        res = %Response{headers: headers, body: body, status_code: 301},
        _req = %Request{path: path, headers: headers},
        media_type
      ) do
    redirect_headers =
      headers
      |> content(media_type, body)
      |> host(headers)
      |> allow(@routes.routes[path][:methods])

    %{res | headers: redirect_headers}
  end

  def build(res, _req = %Request{headers: headers}, media_type) do
    headers =
      res.headers
      |> content(media_type, res.body)
      |> host(headers)

    %{res | headers: headers}
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
