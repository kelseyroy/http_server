defmodule HTTPServer do
  alias HTTPServer.Response
  alias HTTPServer.Request
  alias HTTPServer.Router
  alias HTTPServer.Routes
  require Record
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
    request =
      socket
      |> read_line()
      |> Request.parse_request()

    response =
      determine_routes()
      |> Router.router(request)
      |> Response.format_response()

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

  def determine_routes do
    env = Mix.env()

    case env do
      :unit_test -> &HTTPServerTestFixture.Routes.route/1
      :test -> &HTTPServerFixture.Routes.route/1
      _ -> &Routes.route/1
    end
  end
end
