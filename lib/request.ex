defmodule HTTPServer.Request do
  defstruct method: nil, path: "", resource: nil, headers: %{}, body: ""
  @type method :: :get | :post | nil
end
