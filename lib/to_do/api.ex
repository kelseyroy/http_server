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

  def delete(path) do
    id = parse_id_from_path(path)

    DB.all()
    |> DB.delete_todo(id)
    |> DB.save()
  end

  defp parse_id_from_path(path) do
    [id | _] = path |> String.split("/")
    id
  end
end
