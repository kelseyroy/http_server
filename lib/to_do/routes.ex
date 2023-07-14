defmodule ToDo.Routes do
  def routes, do: %{
    "/todo" => %{
      handler: ToDo.Handlers.ToDo,
      methods: ["POST"]
    },
    # "/todo/#{is_integer()}" => %{
    #   handler: ToDo.Handlers.ToDo,
    #   methods: ["POST"]
    # }
  }
end
