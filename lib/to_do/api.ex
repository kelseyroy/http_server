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

  def delete(id) do
    DB.all()
    |> DB.delete_todo(id)
    |> DB.save()
  end

  def update({:ok, data}, id) do
    DB.all()
    |> DB.edit_todo(id, data)
    |> case do
      :error -> {:error, data}
      {:ok, value} -> DB.save(value)
    end
  end

  def update({:error, error_message}, _id) do
    error_message
  end
end
