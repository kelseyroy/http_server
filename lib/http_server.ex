defmodule HTTPServer do
  alias HTTPServer.Response
  alias HTTPServer.Request
  require Record
  require Logger
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
      |> decode()
      |> parse()

    response =
      request
      |> encode()

    socket
    |> write_line(response)
    |> serve()

    # socket
    # |> read_line()
    # # |> parse()
    # |> write_line(socket)
    # |> serve()
  end

  defp read_line(socket) do
    {:ok, data} = :gen_tcp.recv(socket, 0)
    data
  end

  defp decode(req) do
    URI.decode(req)
  end

  defp encode(res) do
    inspect(res) |> URI.encode()
  end

  defp write_line(socket, data) do
    :gen_tcp.send(socket, data)
    socket
  end

  def parse(message) do
    [request_data | body] = message |> String.split("\r\n\r\n")
    [first | headers] = request_data |> String.split("\r\n")
    [method, path, resource] = first |> String.split(" ")

    req = %Request{
      method: method,
      path: path,
      resource: resource,
      headers: format_headers(headers, %{}),
      body: hd(body)
    }

    case method do
      "" ->
        hd(body)

      "POST" ->
        %{req | method: :post}
    end
  end

  def build_response(req) do
    %Response{
      status_code: 200,
      status_message: :ok,
      resource: req.resource,
      headers: req.headers,
      body: req.body
    }
  end

  def text(res) do
    "#{res.resource} #{res.status_code} OK\r\n" <>
      "#{response_headers(res.headers)}" <>
      "\r\n" <>
      "#{res.body}"
  end

  def response_headers(headers) do
    for {key, val} <- headers, into: "", do: "#{key}: #{val}\r\n"
  end

  defp format_headers([head | tail], headers) do
    [key, value] = head |> String.split(": ")
    headers = Map.put(headers, key, value)
    format_headers(tail, headers)
  end

  defp format_headers([], headers), do: headers
end
