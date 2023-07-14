defmodule HTTPServerTest.ToDo do
  alias ToDo.API
  use ExUnit.Case, async: true
  doctest HTTPServer

  @file_path Application.compile_env(
               :http_server,
               :file_path,
               "lib/http_server_test_fixture/mock_data/test-data.json"
             )

  setup do
    act_arrange_test_todo = JSON.encode!(%{"1" => %{"todo1" => "Act"}, "2" => %{"todo2" => "Arrange"}})
    File.write!(@file_path, act_arrange_test_todo)
  end

  test "Can write \"{\"todo3\":\"Assert\"}\" to data file without overwriting previous data" do
    todo_to_add = %{"todo3" => "Assert"}
    handle_resp = {:ok, todo_to_add}

    expected_file_contents = %{
      "1" => %{"todo1" => "Act"},
      "2" => %{"todo2" => "Arrange"},
      "3" => %{"todo3" => "Assert"}
    }

    API.create(handle_resp)

    file_contents =
      File.read!(@file_path)
      |> JSON.decode!()

    assert file_contents == expected_file_contents
  end

  test "Returns error message when passed {:error, \"Error Message\"}" do
    error_message = "Error Message"
    handle_resp = {:error, error_message}

    assert API.create(handle_resp) == error_message
  end

  test "Can delete \"{\"todo1\":\"Act\"}\" from data file" do
    todo_to_be_deleted = "1"

    API.delete(todo_to_be_deleted)

    file_contents =
      File.read!(@file_path)
      |> JSON.decode!()

    refute file_contents[todo_to_be_deleted]
  end
end
