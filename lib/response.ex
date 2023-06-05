defmodule HTTPServer.Response do
  defstruct status_code: 404, status_message: :not_found, resource: nil, headers: %{}, body: ""
  @type status_code :: 200 | 404
  @type status_message :: :ok | :not_found

  def status_message(status_code) do
    %{
      200 => "OK",
      404 => "NOT FOUND"
    }[status_code]
  end
end
