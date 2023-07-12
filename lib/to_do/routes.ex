defmodule ToDo.Routes do
  def routes, do: %{
    "/todo" => %{
      handler: ToDoAPI.Handlers.ToDo,
      methods: ["POST"]
    },
  }
end
