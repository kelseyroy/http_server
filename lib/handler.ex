defmodule HTTPServer.Handler do
  alias HTTPServer.Request

  @callback handle(req :: %Request{}) ::
              {status_code :: integer(), body :: term(), media_type :: atom()}
end
