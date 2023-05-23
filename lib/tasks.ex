defmodule Mix.Tasks.Start do
  use Mix.Task

  def run(_) do
    port = String.to_integer(System.get_env("PORT") || "4040")
    HTTPServer.accept(port)
  end
end
