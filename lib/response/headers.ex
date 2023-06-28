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

  def build(res, req = %Request{method: "OPTIONS"}, media_type) do
    headers =
      res.headers
      |> content(media_type, res.body)
      |> host(req.headers)
      |> allow(@routes.routes[req.path][:methods])

    %{res | headers: headers}
  end

  def build(res = %Response{status_code: 405}, req, media_type) do
    headers =
      res.headers
      |> content(media_type, res.body)
      |> host(req.headers)
      |> allow(@routes.routes[req.path][:methods])

    %{res | headers: headers}
  end

  def build(res = %Response{status_code: 301}, req, media_type) do
    headers =
      res.headers
      |> content(media_type, res.body)
      |> host(req.headers)
      |> location(@routes.routes[req.path][:location])

    %{res | headers: headers}
  end

  def build(res, req, media_type) do
    headers =
      res.headers
      |> content(media_type, res.body)
      |> host(req.headers)

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
