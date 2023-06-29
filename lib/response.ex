defmodule HTTPServer.Response do
  alias HTTPServer.Request
  alias HTTPServer.Response.Headers

  defstruct status_code: nil,
            status_message: "",
            resource: nil,
            headers: %{},
            body: ""

  @type t :: %__MODULE__{
          status_code: 200 | 204 | 404 | 301 | 405,
          status_message: String.t(),
          resource: String.t(),
          headers: %Headers{},
          body: String.t()
        }

  @carriage_return "\r\n"

  def send_resp(resp) do
    %{resp | headers: Headers.collect_headers(resp.headers)}
  end

  def build(req = %Request{method: "HEAD"}, status_code, res_body, media_type) do
    resp =
      new()
      |> status(status_code)
      |> body(res_body)
      |> Headers.build(req, media_type)

    send_resp(%{resp | body: ""})
  end

  def build(req, status_code, res_body, media_type) do
    new()
    |> status(status_code)
    |> body(res_body)
    |> Headers.build(req, media_type)
    |> send_resp()
  end

  def new() do
    %__MODULE__{
      status_code: nil,
      status_message: nil,
      resource: "HTTP/1.1",
      headers: Headers.new(),
      body: nil
    }
  end

  def status(res, status_code),
    do: %{res | status_code: status_code, status_message: status_message(status_code)}

  def body(res, body), do: %{res | body: body}

  defp status_message(status_code) do
    %{
      200 => "OK",
      204 => "NO CONTENT",
      404 => "NOT FOUND",
      301 => "MOVED PERMANENTLY",
      405 => "METHOD NOT ALLOWED"
    }[status_code]
  end

  def format_response(
        _res = %__MODULE__{
          resource: resource,
          status_code: status_code,
          status_message: status_message,
          body: body,
          headers: headers
        }
      ) do
    "#{resource} #{status_code} #{status_message}" <>
      @carriage_return <>
      "#{Headers.format_response_headers(headers)}" <>
      @carriage_return <>
      body
  end
end
