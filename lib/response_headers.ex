defmodule HTTPServer.Response.Headers do
  defstruct content_length: nil, content_type: nil, host: nil, location: nil, allow: nil

  @type t :: %__MODULE__{
          content_length: non_neg_integer(),
          content_type: String.t(),
          host: String.t(),
          location: String.t(),
          allow: list(String.t())
        }
end
