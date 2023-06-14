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

## Connecting to the server as a Client

### Send a Request Using Postman
1. [Install Postman](https://learning.postman.com/docs/getting-started/installation-and-updates/) as a native desktop app on your computer or access the app via the web at [https://web.postman.co/home](https://web.postman.co/home).
2. Login to your Postman account or create a [free Postman account](https://www.postman.com/postman-account/).
3. Create and name a new Collection in the app and select `Add request` to start building your request.
4. Input the request URL as `http://localhost:4000/` or `127.0.0.1:4000/`
5. Select a method from the drop down list to the left of the URL.
6. Optionally add a Body to your request or customize which Headers you want your request to include.
7. Hit Send to send the request and receive a response.

### Create Custom Routing

Right now, all requests sent to the server should receive a response back with a status code of `404`, or `NOT FOUND`. This is because the HTTP Server's routing has not yet been set up! Routing refers to the functionality of how an application handles and ultimately responds to a request at a particular endpoint. The endpoint is determined by the Path (also known as a URI) and HTTP request method (GET, POST, HEAD, DELETE, OPTIONS, etc.) passed to the application in the request. It's up to you to customize the routes you want your application to accept and the handler functions that determine what actions the application should take when the route is matched. 

#### Anatomy of a Route:

Each route takes the following structure:

```
def route(%Request{path: PATH} = req), do: HandlerModule.handle(req)
```

* `route/1` is a function that accepts a request object and pattern matches on a specific path.
* `PATH` is a path on the server.
* `HandlerModule.handle(req)` is the function that is executed when the route is matched.

It's important to note that any custom routes you create should be added *above* the default route in the `HTTPServer.Routes` module in `lib/routes.ex`. It can also be helpful to setup the full name of your `HandlerModule` as an `alias/2` at the top of the `HTTPServer.Routes` module.

#### Anatomy of Handlers:

The application's handlers are housed in the `lib/handlers` folder. Each handler module takes the following structure:

```
defmodule HTTPServer.Handlers.MODULE_NAME do
  alias HTTPServer.Request
  @behaviour HTTPServer.Handler

  @impl HTTPServer.Handler
  def handle(%Request{method: METHOD} = req) do
    {STATUS_CODE, RESPONSE_BODY}
  end
end
```

* `MODULE_NAME` is the custom name of your handler module, which is extension of `HTTPServer.Handlers`. The module name is written in camel case and must match the text in the file name, which is written in snake case.
* `handle/1` is the function that is executed when the route is matched. It accepts a request object and pattern matches on the specified method. There can be multiple `handle/1` functions in the same handler module so long as the `METHOD` is different.
* `req` is a variable that represents the Request object. If the variable is not meant to be used, you must prefix it with an underscore.
* `METHOD` is an [HTTP request method](https://en.wikipedia.org/wiki/HTTP#Request_methods) as a string in all capital letters.
* `STATUS_CODE` is an [HTTP response status code](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes) as an integer.
* `RESPONSE_BODY` is the body of the response object that will be sent back to the client.

### An Example

Let's say I want my app to respond to GET requests with "Hello World!" on the root route (/), also known as the application's home page.

First, I'll create a new file called `hello_world.ex` in the `lib/handlers` folder. In that file I'll add my new handler module:

```
defmodule HTTPServer.Handlers.HelloWorld do
  alias HTTPServer.Request
  @behaviour HTTPServer.Handler

  @impl HTTPServer.Handler
  def handle(%Request{method: "GET"} = _req) do
    {200, "Hello World!"}
  end
end
```

Next I'll update the `lib/routes.ex` file to include the new route and it's corresponding handler:

```
defmodule HTTPServer.Routes do
  alias HTTPServer.Request
  alias HTTPServer.Handlers.NotFound
  alias HTTPServer.Handlers.HelloWorld

  def route(%Request{path: "/"} = req), do: HelloWorld.handle(req)
  def route(%Request{path: _path} = req), do: NotFound.handle(req)
end
```

What if I want my app to also respond to POST requests with the request body on the homepage? I would update my HelloWorld module to look like:

```
defmodule HTTPServer.Handlers.HelloWorld do
  alias HTTPServer.Request
  @behaviour HTTPServer.Handler

  @impl HTTPServer.Handler
  def handle(%Request{method: "GET"} = _req) do
    {200, "Hello World!"}
  end
  def handle(%Request{method: "POST"} = req) do
    {200, req.body}
  end
end
```

And the `HTTPServer.Routes` module can remain the same!

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
