defmodule HTTPServer.Response do
  defstruct status_code: nil, status_message: "", resource: nil, headers: %{}, body: ""

  @type t :: %__MODULE__{
    status_code: 200 | 404,
    status_message: String.t(),
    resource: String.t(),
    headers: %{optional(String.t()) => any},
    body: String.t()
  }

  @carriage_return "\r\n"

  def send_resp(status_code, body \\ "", headers) do
    %__MODULE__{
      status_code: status_code,
      status_message: status_message(status_code),
      resource: "HTTP/1.1",
      headers: headers,
      body: body
    }
  end

  def build_headers(body) do
    %{
      "Content-Length" => "#{String.length(body)}",
      "Content-Type" => "text/plain",
      "Host" => "127.0.0.1:4000"
    }
  end

  defp status_message(status_code) do
    %{
      200 => "OK",
      404 => "NOT FOUND"
    }[status_code]
  end

  def format_response(res) do
    "#{res.resource} #{res.status_code} #{res.status_message}" <>
      @carriage_return <>
      "#{format_response_headers(res.headers)}" <>
      @carriage_return <>
      "#{res.body}"
  end

  defp format_response_headers(headers) do
    for {key, val} <- headers, into: "", do: "#{key}: #{val}#{@carriage_return}"
  end
end
