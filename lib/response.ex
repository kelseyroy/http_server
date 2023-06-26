defmodule HTTPServer.Response do
  alias HTTPServer.Response.Headers
  require Logger
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
    Logger.info("HEADERS -> #{headers}")

    response = %__MODULE__{
      status_code: status_code,
      status_message: status_message(status_code),
      resource: "HTTP/1.1",
      headers: headers,
      body: body
    }

    non_nil_headers =
      for {k, v} <- Map.from_struct(response.headers), v != nil, into: %{}, do: {k, v}

    Logger.info("NON_NIL_HEADERS -> #{headers}")
    %{response | headers: non_nil_headers}
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
      "#{format_response_headers(res.headers)}" <>
      @carriage_return <>
      "#{res.body}"
  end

  defp format_response_headers(headers) do
    for {key, val} <- headers, into: "", do: "#{dasherize(key)}: #{val}#{@carriage_return}"
  end

  defp dasherize(key) do
    to_string(key)
    |> String.split("_")
    |> Enum.map(&String.capitalize/1)
    |> Enum.join("-")
  end
end
