defmodule HTTPServer.Request do
  defstruct method: :post, path: "", resource: nil, headers: %{}, body: ""
  @type method :: :get | :post | nil
end
