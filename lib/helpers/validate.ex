defmodule HTTPServer.Helpers.Validate do
  alias HTTPServer.Request

  def is_type(%Request{headers: headers}, supported_types) do
    type = normalize_type(headers)

    type in supported_types
  end

  defp normalize_type(headers) do
    unless headers["Content-Type"] == nil do
      [type | _parameter] = headers["Content-Type"] |> String.split(";", parts: 2)
      type
    end
  end
end
