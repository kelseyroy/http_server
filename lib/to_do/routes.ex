defmodule ToDo.Routes do
  def routes, do: %{
    "/todo" => %{
      handler: ToDo.Handlers.ToDo,
      methods: ["POST", "DELETE"]
    },
  }
end
