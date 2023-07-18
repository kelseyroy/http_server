defmodule ToDo.API do
  alias ToDo.DB

  def create({:ok, data}) do
    DB.all()
    |> DB.add_new_todo(data)
    |> DB.save()
  end

  def create({:error, error_message}) do
    error_message
  end
end
