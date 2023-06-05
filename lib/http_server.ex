defmodule HTTPServer do
  # alias HTTPServer.Response
  alias HTTPServer.Request
  alias HTTPServer.Router
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
      |> parse_request()

    response =
      request
      |> Router.route()
      |> format_response()

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

  def parse_request(message) do
    [request_data | body] = message |> String.split("\r\n\r\n")
    [first | headers] = request_data |> String.split("\r\n")
    [method, path, resource] = first |> String.split(" ")

    req = %Request{
      method: method,
      path: path,
      resource: resource,
      headers: parse_headers(headers, %{}),
      body: hd(body)
    }

    case method do
      "POST" ->
        %{req | method: :post}

      _ ->
        {:error, :unknown_command}
    end
  end

  # def build_response(req) do
  #   %Response{
  #     status_code: 200,
  #     status_message: :ok,
  #     resource: req.resource,
  #     headers: req.headers,
  #     body: req.body
  #   }
  # end

  def format_response(res) do
    carriage_return = "\r\n"

    "#{res.resource} #{res.status_code} OK" <>
      carriage_return <>
      "#{format_response_headers(res.headers)}" <>
      carriage_return <>
      "#{res.body}"
  end

  def format_response_headers(headers) do
    for {key, val} <- headers, into: "", do: "#{key}: #{val}\r\n"
  end

  defp parse_headers([head | tail], headers) do
    [key, value] = head |> String.split(": ")
    headers = Map.put(headers, key, value)
    parse_headers(tail, headers)
  end

  defp parse_headers([], headers), do: headers
end
