defmodule HTTPServer.Response.HeadersBuilder do
  def content_length(headers, body), do: %{headers | content_length: String.length(body)}
  def content_type(headers), do: %{headers | content_type: "text/plain"}
  def host(headers, req_headers), do: %{headers | host: "#{get_host(req_headers)}"}

  def location(headers, req_headers, path),
    do: %{headers | location: "http://#{get_host(req_headers)}#{path}"}

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
