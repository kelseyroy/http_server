defmodule HTTPServer.Response.Body do
  def handle(body, :json) do
    JSON.decode!(body)
  end
end
