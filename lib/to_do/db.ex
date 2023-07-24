defmodule ToDo.DB do
  @file_path Application.compile_env(:http_server, :file_path, "lib/to_do/data/to_dos.json")

  def all do
    case File.exists?(@file_path) do
      true -> File.read!(@file_path) |> JSON.decode!()
      false -> %{}
    end
  end

  def save(data), do: File.write(@file_path, JSON.encode!(data), [:write])

  def add_new_todo(todo_data, new_todo) do
    Map.put(todo_data, get_id(todo_data), new_todo)
  end

  def delete_todo(data, key) do
    {_value, new_map} = Map.pop(data, key)
    new_map
  end

  def edit_todo(data, key, value) do
    # %{data | key => value}
    case Map.fetch(data, key) do
      {:ok, _value} ->  {:ok, %{data | key => value}}
      :error -> :error
    end
  end

  defp get_id(todo_data) do
    keys = Map.keys(todo_data) |> Enum.map(&String.to_integer/1)
    n = length(keys) + 1
    expected_sum = n * (n + 1) / 2
    actual_sum = Enum.sum(keys)
    result = trunc(expected_sum - actual_sum)

    if result == 0 do
      to_string(n)
    else
      to_string(result)
    end
  end
end
