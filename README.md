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
4. To connect to the Server as a client, [install telnet](https://formulae.brew.sh/formula/telnet) and call `telnet 127.0.0.1 4000` in a local terminal.

## Testing
### Running the ExUnit Test Suite:
To run the ExUnit test suite, call `mix test` from within the http_server folder.

### Acceptance Tests:

#### Dependencies
* Ruby 2.7.6

#### Running the Acceptance Test Suite:
1. Start your HTTP server by calling `MIX_ENV=test mix start` from within the http_server folder.
2. Use your terminal to navigate into the `test/http_server_spec` folder and install project dependencies by running `bundle install`.
3. Once the server is running, call `rake test` from within the http_server_spec folder.
4. You can also run the tests from a specific section of the features:

```
rake test:f1 # Run all of the tests in 01_getting_started
rake test:f2 # Run all of the tests in 02_structured_data
rake test:f3 # Run all of the tests in 03_file_server
rake test:f4 # Run all of the tests in 04_todo_list
```
See `test/http_server_spec/README.md` for more information about the acceptance tests.
