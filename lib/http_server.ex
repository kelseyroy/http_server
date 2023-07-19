defmodule HTTPServer do
  alias HTTPServer.Response
  alias HTTPServer.Request
  alias HTTPServer.Router
  require Record
  require Logger

  def accept(port) do
    tcp_options = [:binary, {:packet, 0}, {:active, false}, reuseaddr: true]
    {:ok, listen_socket} = :gen_tcp.listen(port, tcp_options)
    log("Accepting connections on port #{port}")
    listen(listen_socket)
  end

  defp listen(listen_socket) do
    log("---------- Waiting for request ----------")
    {:ok, accept_socket} = :gen_tcp.accept(listen_socket)
    spawn(fn -> serve(accept_socket) end)
    listen(listen_socket)
  end

  defp serve(socket) do
    request =
      socket
      |> read_line()
      |> log("Request:")
      |> Request.parse()

    response =
      request
      |> Router.router()
      |> Response.format_response()
      |> log("Response:")

    socket
    |> write_line(response)
    |> serve()
  end

  defp read_line(socket) do
    case :gen_tcp.recv(socket, 0) do
      {:ok, data} ->
        data

      {:error, :econnrefused} ->
        exit(:normal)

      {:error, :closed} ->
        exit(:normal)
    end
  end

  defp write_line(socket, data) do
    :gen_tcp.send(socket, data)
    socket
  end

  defp log(message), do: Logger.info(message)

  defp log(data, message) do
    Logger.info(message <> "\n\n" <> data)
    data
  end
end
