defmodule HTTPServer.Response.HeadersBuilder do
  defp content_length(headers, body), do: %{headers | content_length: byte_size(body)}
  defp content_type(headers, media_type), do: %{headers | content_type: media_type}
  def host(headers, req_headers), do: %{headers | host: "#{get_host(req_headers)}"}

  def content(headers, :text, body) do
    headers
    |> content_length(body)
    |> content_type("text/plain;charset=utf-8")
  end

  def content(headers, :html, body) do
    headers
    |> content_length(body)
    |> content_type("text/html;charset=utf-8")
  end

  def content(headers, :json, json_body) do
    headers
    |> content_length(json_body)
    |> content_type("application/json;charset=utf-8")
  end

  def content(headers, :xml, body) do
    headers
    |> content_length(body)
    |> content_type("application/xml;charset=utf-8")
  end

  def location(headers, path),
    do: %{headers | location: "http://#{Map.get(headers, :host)}#{path}"}

  def allow(headers, methods) do
    methods =
      if Enum.member?(methods, "GET") do
        methods ++ ["HEAD", "OPTIONS"]
      else
        methods ++ ["OPTIONS"]
      end

    %{headers | allow: "#{Enum.join(methods, ", ")}"}
  end

  defp get_host(req_headers) do
    case Map.fetch(req_headers, "Host") do
      {:ok, host} -> host
      :error -> "0.0.0.0:4000"
    end
  end
end
