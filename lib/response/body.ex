defmodule HTTPServer.Response.Body do
  alias HTTPServer.Request
  alias HTTPServer.Router.Handlers.UnsupportedMediaType
  def handle(%Request{body: body, headers: headers} = req, :json) do
    case is_type(headers, :json) do
      true -> JSON.decode(body)

      false -> {:error, UnsupportedMediaType.handle(req)}
    end

  end

  defp is_type(headers, :json) do
    type = normalize_type(headers)

    type in ["application/*", "application/json"]
  end

  defp normalize_type(headers) do
    unless headers["Content-Type"] == nil do
      [type | _parameter] = headers["Content-Type"] |> String.split(";", parts: 2)
      type
    end
  end
end
