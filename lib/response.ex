defmodule HTTPServer.Response do
  defstruct status_code: nil, status_message: "", resource: nil, headers: %{}, body: ""

  @type t :: %__MODULE__{
          status_code: 200 | 204 | 404,
          status_message: String.t(),
          resource: String.t(),
          headers: %{optional(String.t()) => any},
          body: String.t()
        }

  @carriage_return "\r\n"
  @host "0.0.0.0:4000"

  def send_resp(status_code, body \\ "", headers \\ %{}) do
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
      "Host" => @host
    }
  end

  def build_headers(body, headers) do
    Map.merge(build_headers(body), headers)
  end

  def build_allow_header(methods) do
    methods =
      if Enum.member?(methods, "GET") do
        methods ++ ["HEAD", "OPTIONS"]
      else
        methods ++ ["OPTIONS"]
      end

    %{
      "Allow" => "#{Enum.join(methods, ", ")}"
    }
  end

  def build_location_header(path) do
    %{
      "Location" => "http://#{@host}#{path}"
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
      "#{format_response_headers(res.headers)}" <>
      @carriage_return <>
      "#{res.body}"
  end

  defp format_response_headers(headers) do
    for {key, val} <- headers, into: "", do: "#{key}: #{val}#{@carriage_return}"
  end
end
