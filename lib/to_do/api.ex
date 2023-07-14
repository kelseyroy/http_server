defmodule ToDo.API do
  @file_path Application.compile_env(:http_server, :file_path, "lib/to_do/data/to_dos.json")

  def create({:ok, data}) do
    read_file()
    |> add_new_todo(data)
    |> write_file()
  end

  def create({:error, error_message}) do
    error_message
  end

  defp read_file, do: File.read!(@file_path) |> JSON.decode!()

  defp write_file(data), do: File.write(@file_path, JSON.encode!(data), [:read, :write])

  defp add_new_todo(todo_data, new_todo) do
    Map.put(todo_data, get_id(todo_data), new_todo)
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
