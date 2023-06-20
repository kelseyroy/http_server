defmodule HTTPServer.Routes do
  alias HTTPServer.Request

  @callback fetch_route(path :: String.t()) :: {:ok, methods :: list()} | {:error}

  @callback route(req :: %Request{}) :: {status_code :: integer(), body :: term()}
end
