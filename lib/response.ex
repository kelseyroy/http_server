defmodule HTTPServer.Response do
  alias HTTPServer.Request
  alias HTTPServer.Response.Headers

  defstruct status_code: nil,
            status_message: "",
            resource: nil,
            headers: %{},
            body: ""

  @type t :: %__MODULE__{
          status_code: 200 | 204 | 404 | 301 | 405 | 415,
          status_message: String.t(),
          resource: String.t(),
          headers: %Headers{},
          body: String.t()
        }

  @carriage_return "\r\n"

  defp send_resp(resp) do
    %{resp | headers: Headers.collect_headers(resp.headers)}
  end

  def build(req = %Request{method: "HEAD"}, status_code, res_body, media_type) do
    resp = build(%Request{req | method: "GET"}, status_code, res_body, media_type)
    %{resp | body: ""}
  end

  def build(req, status_code, res_body, media_type) do
    %__MODULE__{}
    |> resource()
    |> status(status_code)
    |> body(media_type, res_body)
    |> headers(req, media_type)
    |> send_resp()
  end

  defp headers(res = %__MODULE__{status_code: status_code, body: body}, req, media_type),
    do: %{res | headers: Headers.build(req, status_code, body, media_type)}

  defp resource(res), do: %{res | resource: "HTTP/1.1"}

  defp status(res, status_code),
    do: %{res | status_code: status_code, status_message: status_message(status_code)}

  defp body(res, :json, res_body) do
    {:ok, json_body} = JSON.encode(res_body)
    %{res | body: json_body}
  end

  defp body(res, _media_type, res_body), do: %{res | body: res_body}

  defp status_message(status_code) do
    %{
      200 => "OK",
      204 => "NO CONTENT",
      404 => "NOT FOUND",
      301 => "MOVED PERMANENTLY",
      405 => "METHOD NOT ALLOWED",
      415 => "UNSUPPORTED MEDIA TYPE"
    }[status_code]
  end

  def format_response(%__MODULE__{
        resource: resource,
        status_code: status_code,
        status_message: status_message,
        body: body,
        headers: headers
      }) do
    "#{resource} #{status_code} #{status_message}" <>
      @carriage_return <>
      "#{Headers.format_response_headers(headers)}" <>
      @carriage_return <>
      body
  end
end
