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
    act_arrange_test_todo =
      JSON.encode!(%{
        "1" => %{"todo1" => "Act"},
        "2" => %{"todo2" => "Arrange"},
        "4" => %{"todo4" => "Teardown"}
      })

    File.write(@file_path, act_arrange_test_todo)
    :ok
  end

  test "Can add valid ToDo \"{\"todo3\":\"Assert\"}\"" do
    todo_to_add = %{"todo3" => "Assert"}
    handle_resp = {:ok, todo_to_add}

    expected_file_contents = %{
      "1" => %{"todo1" => "Act"},
      "2" => %{"todo2" => "Arrange"},
      "3" => %{"todo3" => "Assert"},
      "4" => %{"todo4" => "Teardown"}
    }

    API.create(handle_resp)

    file_contents =
      File.read!(@file_path)
      |> JSON.decode!()

    assert file_contents == expected_file_contents
  end

  test "Returns error message when ToDo is formatted incorrectly for create" do
    error_message = "Error Message"
    handle_resp = {:error, error_message}

    assert API.create(handle_resp) == error_message
  end

  test "Can delete the first valid ToDo from the ToDo list" do
    todo_to_be_deleted = "1"

    API.delete(todo_to_be_deleted)

    file_contents =
      File.read!(@file_path)
      |> JSON.decode!()

    refute file_contents[todo_to_be_deleted]
  end

  test "Can delete the last valid ToDo from the ToDo list" do
    todo_to_be_deleted = "4"

    API.delete(todo_to_be_deleted)

    file_contents =
      File.read!(@file_path)
      |> JSON.decode!()

    refute file_contents[todo_to_be_deleted]
  end

  test "Cannot delete a ToDo with an id that doesn't exist" do
    non_existant_todo_id = "5"

    test_todos =
      File.read!(@file_path)
      |> JSON.decode!()

    API.delete(non_existant_todo_id)

    test_todos_after_delete =
      File.read!(@file_path)
      |> JSON.decode!()

    assert test_todos == test_todos_after_delete
  end

  test "Cannot delete a ToDo with an id that is malformed" do
    malformed_todo_id = "0.5"

    test_todos =
      File.read!(@file_path)
      |> JSON.decode!()

    API.delete(malformed_todo_id)

    test_todos_after_delete =
      File.read!(@file_path)
      |> JSON.decode!()

    assert test_todos == test_todos_after_delete
  end

  test "Cannot delete from an empty ToDo list." do
    todo_to_be_deleted = "1"
    if File.exists?(@file_path), do: File.rm!(@file_path)

    API.delete(todo_to_be_deleted)

    file_contents =
      File.read!(@file_path)
      |> JSON.decode!()

    assert %{} == file_contents
  end

  test "Can update valid ToDo" do
    todo_to_update = "1"
    updated_todo_data = %{"task" => "This is a new task"}
    handle_resp = {:ok, updated_todo_data}

    API.update(handle_resp, todo_to_update)

    file_contents =
      File.read!(@file_path)
      |> JSON.decode!()

    assert updated_todo_data == file_contents[todo_to_update]
  end

  test "Returns error message when ToDo is formatted incorrectly for update" do
    error_message = "Error Message"
    handle_resp = {:error, error_message}

    assert API.update(handle_resp, "1") == error_message
  end

  test "Cannot update a ToDo with an id that doesn't exist" do
    non_existant_todo_id = "5"
    updated_todo_data = %{"task" => "This is a new task"}
    handle_resp = {:ok, updated_todo_data}

    actual_result = API.update(handle_resp, non_existant_todo_id)

    expected_result = {:error, updated_todo_data}

    assert expected_result == actual_result
  end
end
