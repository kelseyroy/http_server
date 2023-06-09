defmodule ToDo.API do
  @file_path Application.compile_env(:http_server, :file_path, "lib/to_do/data/to_dos.json")

  def create({:ok, data}) do
    new_save_data =
      File.read!(@file_path)
      |> JSON.decode!()
      |> Map.merge(data)
      |> JSON.encode!()

    File.write(@file_path, new_save_data, [:read, :write])
  end

  def create({:error, error_message}) do
    error_message
  end
end
