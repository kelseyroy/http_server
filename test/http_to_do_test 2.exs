defmodule HTTPServerTest.ToDo do
  alias ToDo.API
  use ExUnit.Case
  doctest HTTPServer

  setup do
    mock_data = JSON.encode!(%{"todo1" => "Act", "todo2" => "Arrange"})
    File.write!("lib/http_server_test_fixture/mock_data/test-data.json", mock_data)
    on_exit(fn -> File.rm!("lib/http_server_test_fixture/mock_data/test-data.json") end)
    [mock_data: %{"todo1" => "Act", "todo2" => "Arrange"}]
  end

  test "Can write \"{\"todo3\":\"Assert\"}\" to data file without overwriting previous data" do
    todo_to_add = %{"todo3" => "Assert"}
    expected_file_contents = Map.merge(%{"todo1" => "Act", "todo2" => "Arrange"}, todo_to_add)

    API.create(todo_to_add)

    file_contents =
      File.read!("lib/http_server_test_fixture/mock_data/test-data.json")
      |> JSON.decode!()

    assert file_contents == expected_file_contents
  end
end
