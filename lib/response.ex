defmodule HTTPServer.Response do
  alias HTTPServer.Response.Headers
  defstruct status_code: nil, status_message: "", resource: nil, headers: %{}, body: ""

  @type t :: %__MODULE__{
          status_code: 200 | 204 | 404,
          status_message: String.t(),
          resource: String.t(),
          headers: %Headers{},
          body: String.t()
        }

  @carriage_return "\r\n"

  def send_resp(status_code, body, headers) do
    %__MODULE__{
      status_code: status_code,
      status_message: status_message(status_code),
      resource: "HTTP/1.1",
      headers: Headers.collect_headers(headers),
      body: body
    }
  end

  defp status_message(status_code) do
    %{
      200 => "OK",
      204 => "NO CONTENT",
      404 => "NOT FOUND",
      301 => "MOVED PERMANENTLY"
    }[status_code]
  end

  def format_response(res) do
    "#{res.resource} #{res.status_code} #{res.status_message}" <>
      @carriage_return <>
      "#{Headers.format_response_headers(res.headers)}" <>
      @carriage_return <>
      "#{res.body}"
  end
end
