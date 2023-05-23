# HTTPServer

Build an echo server that can accept a message from a client and send back the same message it was sent.

## Functional Requirements
A user should be able to interact with the echo server as follows:

* When a client sends a message to the server, the server sends a response back to the client containing the original message.
* A client can send multiple messages to the server and get the echoed response back each time.
* Multiple clients can send messages to server and get back their proper responses.

## Implementation Requirements
* The server should establish a socket connection with the client using a low-level socket library. The goal of this exercise is to work with sockets directly.
* The server should accept and return streams of data rather than raw strings.
* The echo server should be covered by a robust suite of ExUnit tests.
* The echo server will be built using Elixir.

## Dependencies
* Elixir 1.14.x
* Erlang/OTP 25

## Setup
1. [Clone the repository](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository) to your local computer.
2. Use your terminal to navigate into your new http_server folder and install project dependencies by running `mix compile`.
3. To start the Echo Server, call `mix start` from within the http_server folder.
4. To run the tests, call `mix test` from within the http_server folder.
