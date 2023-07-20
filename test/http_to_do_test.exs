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

  test "Can write \"{\"todo3\":\"Assert\"}\" to data file without overwriting previous data" do
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

  test "Can delete \"{\"todo4\":\"Teardown\"}\" from data file" do
    todo_to_be_deleted = "4"

    API.delete(todo_to_be_deleted)

    file_contents =
      File.read!(@file_path)
      |> JSON.decode!()

    refute file_contents[todo_to_be_deleted]
  end

  test "The file will not change when id = 5" do
    todo_to_be_deleted = "5"

    data_before_delete =
      File.read!(@file_path)
      |> JSON.decode!()

    API.delete(todo_to_be_deleted)

    data_after_delete =
      File.read!(@file_path)
      |> JSON.decode!()

    assert data_before_delete == data_after_delete
  end


  test "The file will not change when id = 0.5" do
    todo_to_be_deleted = "0.5"

    data_before_delete =
      File.read!(@file_path)
      |> JSON.decode!()

    API.delete(todo_to_be_deleted)

    data_after_delete =
      File.read!(@file_path)
      |> JSON.decode!()

    assert data_before_delete == data_after_delete
  end

  test "Returns an empty map when no todos have been created." do
    todo_to_be_deleted = "1"
    if File.exists?(@file_path), do: File.rm!(@file_path)

    API.delete(todo_to_be_deleted)

    file_contents =
      File.read!(@file_path)
      |> JSON.decode!()

    assert %{} == file_contents
  end
end
