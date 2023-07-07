# HTTPServer

## Overview

In this feature, an apprentice will build an HTTP server which includes routes, requests, and responses. The routes must be customizable with a URL, a verb, and an action to take when the route is called. This work will form the basis of many other features.

This feature corresponds to the acceptance tests in `01_getting_started` in the [HTTP Server Spec](https://github.com/8thlight/http_server_spec).

## Functional Requirements

A user should be able to interact with the HTTP server as follows:

* When a client sends a properly formatted request to the server, the server sends an appropriate response back to the client.
* A client can send different HTTP requests to the server and get the appropriate response back each time.
* Different clients can send messages to server and get back their proper responses.
* The server should be able to handle 200, 300, and 400-level responses. Not every response code needs to be complete, but there should be a few representative response codes implemented for each level.

## Implementation Requirements

* The server should establish a socket connection with the client using a low-level socket library. The goal of this exercise is to work with sockets directly.
* The server should accept and return streams of data rather than raw strings.
* The HTTP server should be covered by a robust suite of unit tests.
* The HTTP server should pass all of the tests covered in `01_getting_started` in the [HTTP Server Spec](https://github.com/8thlight/http_server_spec).

## Dependencies
* Elixir 1.14.x
* Erlang/OTP 25
* [Echo Server](https://github.com/8thlight/apprenticeship_syllabus/blob/master/shared_resources/projects/http_server/01_beginner/echo_server.md)

## Setup
1. [Clone the repository](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository) to your local computer.
2. Use your terminal to navigate into your new http_server folder and install project dependencies by running `mix compile`.
3. To start the HTTP Server, call `mix start` from within the http_server folder.

## Using the Server

For more information about [connecting to the server as a client](./doc/using.md), [basic routing](./doc/basic_routing.md), as well as [handling redirects](./doc/redirects.md) and [static files](./doc/static_files.md), please see the doc folder.

## Testing
### Running the ExUnit Test Suite:

To run the ExUnit test suite, call `mix test` from within the http_server folder.

### Acceptance Tests:

#### Dependencies
* Ruby 2.7.6

#### Running the Acceptance Test Suite:
1. Start your HTTP server by calling `MIX_ENV=integration_test mix start` from within the http_server folder.
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
