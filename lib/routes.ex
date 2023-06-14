defmodule HTTPServer.Routes do
  alias HTTPServer.Request
  # alias HTTPServer.Handler
  alias HTTPServer.NotFound

  def route(%Request{path: _path} = req), do: NotFound.handle(req)
end