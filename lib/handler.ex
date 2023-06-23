defmodule HTTPServer.Handler do
  alias HTTPServer.Request

  @callback handle(req :: %Request{}) ::
              {status_code :: integer(), body :: term(), headers :: map()}
end
