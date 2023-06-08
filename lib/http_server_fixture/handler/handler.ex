defmodule HTTPServerFixture.Handler do
  alias HTTPServer.Request
  @callback handle(req :: %Request{}) :: {status_code :: integer(), body :: term()}
end
