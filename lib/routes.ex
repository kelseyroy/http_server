defmodule HTTPServer.Routes do
  alias HTTPServer.Request
  alias HTTPServer.Handlers.NotFound

  def route(%Request{path: _path} = req), do: NotFound.handle(req)
end
