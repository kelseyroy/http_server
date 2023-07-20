defmodule HTTPServer.Request do
  alias HTTPServer.Request.Parser
  defstruct method: "", full_path: [], route_path: "", resource: "", headers: %{}, body: "", params: %{}, id: ""

  @type t :: %__MODULE__{
          method: String.t(),
          full_path: list(String.t()),
          route_path: String.t(),
          resource: String.t(),
          headers: %{optional(String.t()) => any},
          body: String.t(),
          params: %{optional(String.t()) => String.t()},
          id: String.t()
        }

  def parse(message), do: Parser.parse(message)
end
