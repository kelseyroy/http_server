defmodule HTTPServerTest.ToDo do
  alias ToDo.API
  use ExUnit.Case, async: true
  doctest HTTPServer

  @file_path Application.compile_env(:http_server, :file_path, "lib/http_server_test_fixture/mock_data/test-data.json")

  setup do
    mock_data = JSON.encode!(%{"todo1" => "Act", "todo2" => "Arrange"})
    File.write!(@file_path, mock_data)
    [mock_data: %{"todo1" => "Act", "todo2" => "Arrange"}]
  end

  test "Can write \"{\"todo3\":\"Assert\"}\" to data file without overwriting previous data" do
    todo_to_add = %{"todo3" => "Assert"}
    expected_file_contents = Map.merge(%{"todo1" => "Act", "todo2" => "Arrange"}, todo_to_add)

    API.create(todo_to_add)

    file_contents =
      File.read!(@file_path)
      |> JSON.decode!()

    assert file_contents == expected_file_contents
  end
end
