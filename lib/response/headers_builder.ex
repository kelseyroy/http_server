defmodule HTTPServer.Response.HeadersBuilder do
  def content(headers, media_type, body) do
    headers
    |> content_length(body)
    |> content_type(media_type)
  end

  defp content_length(headers, body), do: %{headers | content_length: byte_size(body)}

  defp content_type(headers, media_type), do: %{headers | content_type: content_type(media_type)}

  defp content_type(media_type) do
    %{
      :text => "text/plain;charset=utf-8",
      :html => "text/html;charset=utf-8",
      :json => "application/json;charset=utf-8",
      :xml => "application/xml;charset=utf-8",
      :css => "text/css;charset=utf-8",
      :jpeg => "image/jpeg",
      :png => "image/png",
      :gif => "image/gif"
    }[media_type]
  end

  def host(headers, req_headers), do: %{headers | host: "#{get_host(req_headers)}"}

  def location(headers, path),
    do: %{headers | location: uri(headers, path)}

  defp uri(headers, path), do: URI.encode("http://#{Map.get(headers, :host)}#{path}")

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
