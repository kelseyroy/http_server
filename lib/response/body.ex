defmodule HTTPServer.Response.Body do
  alias HTTPServer.Request
  alias HTTPServer.Router.Handlers.UnsupportedMediaType
  alias HTTPServer.Router.Handlers.BadRequest

  def handle(%Request{headers: headers} = req, :json) do
    case normalize_type(headers) do
      ["application", "json"] -> parse_body(req, :json)
      ["application", _subtype] -> {:error, BadRequest.handle(req)}
      [_type, _subtype] -> {:error, UnsupportedMediaType.handle(req)}
    end
  end

  defp parse_body(%Request{body: body} = req, :json) do
    case JSON.decode(body) do
      {:ok, json_body} -> {:ok, json_body}
      {:error, _} -> {:error, BadRequest.handle(req)}
    end
  end

  defp normalize_type(headers) do
    unless headers["Content-Type"] == nil do
      [type | _parameter] = headers["Content-Type"] |> String.split(";", parts: 2)
      type |> String.split("/", parts: 2)
    end
  end
end
