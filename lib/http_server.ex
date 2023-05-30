defmodule HTTPServer do
  require Logger

  def accept(port) do
    tcp_options = [:binary, {:packet, 0}, {:active, false}, reuseaddr: true]
    {:ok, listen_socket} = :gen_tcp.listen(port, tcp_options)
    Logger.info("Accepting connections on port #{port}")
    listen(listen_socket)
  end

  defp listen(listen_socket) do
    {:ok, accept_socket} = :gen_tcp.accept(listen_socket)
    spawn(fn -> serve(accept_socket) end)
    listen(listen_socket)
  end

  defp serve(socket) do
    socket
    |> read_line()
    |> write_line(socket)
    |> serve()
  end

  defp read_line(socket) do
    {:ok, data} = :gen_tcp.recv(socket, 0)
    data
  end

  defp write_line(data, socket) do
    :gen_tcp.send(socket, data)
    socket
  end
end
