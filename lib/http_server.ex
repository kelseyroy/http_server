defmodule HTTPServer do
  require Logger

  def accept(port) do
    tcp_options = [:binary, {:packet, 0}, {:active, false}, reuseaddr: true]
    {:ok, socket} = :gen_tcp.listen(port, tcp_options)
    Logger.info("Accepting connections on port #{port}")
    listen(socket)
  end

  defp listen(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    spawn(fn -> serve(client) end)
    listen(socket)
  end

  defp serve(socket) do
    socket
    |> read_line()
    |> write_line(socket)

    serve(socket)
  end

  defp read_line(socket) do
    {:ok, data} = :gen_tcp.recv(socket, 0)
    data
  end

  defp write_line(data, socket) do
    :gen_tcp.send(socket, data)
  end
end
