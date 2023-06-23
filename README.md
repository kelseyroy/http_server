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
def routes, 
  do: %{
    "/PATH" => %{
        handler: HandlerModule,
        methods: ["METHOD"]
      }
  }
```

* `routes/0` is a function that holds the routes in a Map data structure. The server path acts as the routes key, with the handler functionality as the value.
* `/PATH` is a path on the server.
* `HandlerModule` is the module that is executed when the route is matched.
* `methods: ["METHOD"]` is a list of [HTTP request method](https://en.wikipedia.org/wiki/HTTP#Request_methods) that the path can respond to. The methods are represented as a string in all capital letters. Possible methods you can include are: ["GET", "POST", "PUT", "DELETE"]. "HEAD" and "OPTIONS" methods should not be specified, as their functionality is already handled by the server itself.

It's important to note that any custom routes you create should be added to the existing `routes/0` map in the `HTTPServer.Routes` module in `lib/routes.ex`. It can also be helpful to setup the full name of your `HandlerModule` as an `alias/2` at the top of the `HTTPServer.Routes` module, but that's not strictly necessary.

#### Anatomy of Handlers:

The application's handlers are housed in the `lib/handlers` folder. Each handler module takes the following structure:

```
defmodule HTTPServer.Handlers.MODULE_NAME do
  alias HTTPServer.Request
  @behaviour HTTPServer.Handler

  @impl HTTPServer.Handler
  def handle(%Request{method: METHOD} = req) do
    {STATUS_CODE, RESPONSE_BODY, %{HEADER_NAME => HEADER_CONTENT}}
  end
end
```

* `MODULE_NAME` is the custom name of your handler module, which is extension of `HTTPServer.Handlers`. The module name is written in camel case and must match the text in the file name, which is written in snake case.
* `handle/1` is the function that is executed when the route is matched. It accepts a request object and pattern matches on the specified method. There can be multiple `handle/1` functions in the same handler module so long as the `METHOD` is different.
* `req` is a variable that represents the Request object. If the variable is not meant to be used, you must prefix it with an underscore.
* `METHOD` is an [HTTP request method](https://en.wikipedia.org/wiki/HTTP#Request_methods) as a string in all capital letters.
* `STATUS_CODE` is an [HTTP response status code](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes) as an integer.
* `RESPONSE_BODY` is the body of the response object that will be sent back to the client.
* `%{HEADER_NAME => HEADER_CONTENT}` are the headers of the response object, represented as key value pairs in an Elixir map, that will be sent back to the client.

If you do not want to build a custom headers map, the server application has a default `build_headers/1` function that automatically builds headers for Content-Length, Content-Type and Host:

```
defmodule HTTPServer.Handlers.MODULE_NAME do
  alias HTTPServer.Request
  alias HTTPServer.Response
  @behaviour HTTPServer.Handler

  @impl HTTPServer.Handler
  def handle(%Request{method: METHOD} = req) do
    {STATUS_CODE, RESPONSE_BODY, Response.build_headers(RESPONSE_BODY)}
  end
end
```

If you want to use those headers but need further cutomization, `build_headers/2` allows you to add additional headers to the 3 default headers provided:

```
defmodule HTTPServer.Handlers.MODULE_NAME do
  alias HTTPServer.Request
  alias HTTPServer.Response
  @behaviour HTTPServer.Handler

  @impl HTTPServer.Handler
  def handle(%Request{method: METHOD} = req) do
    {STATUS_CODE, RESPONSE_BODY, Response.build_headers(RESPONSE_BODY, %{"HEADER_NAME" => "HEADER_CONTENT"})}
  end
end
```

### Handling Redirects

Luckily, the server already has built in handling to accomodate URL redirection/forwarding responses! Redirects allow a user to preserve an existing path while assigning it a new and premanent endpoint. All necessary changes needed to setup URI redirection happen in the `HTTPServer.Routes` module in `lib/routes.ex`:

```
def routes, 
  do: %{
    "/FROM" => %{
        handler: HTTPServer.Handlers.Redirect,
        methods: ["METHOD"],
        location: "/TO"
      },
      "/TO" => %{
        handler: HandlerModule,
        methods: ["METHOD"]
      }
  }
```

* `/FROM` is the original path on the server you are redirecting the client away from. This path will respond to the HTTP Client with a 301 status code, which will send the request to the path specified in the `location:` field.
* `HTTPServer.Handlers.Redirect` is the module that lets you redirect the user to a different URL by sending an HTTP response with status 301.
* `methods: ["METHOD"]` is a list of [HTTP request methods](https://en.wikipedia.org/wiki/HTTP#Request_methods) that the `/TO` path can respond to.
* `location: "/TO"` is the path on the server you are redirecting the client towards. After receiving a response with a 301 status code at the `/FROM` endpoint, the `Location` response header will point toward this path as the new endpoint that will respond to the request.

Please be sure that the `/TO` route and it's handler module is properly setup before redirecting the clients to that path.

### An Example

Let's say I want my app to respond to GET requests with "Hello World!" on the root route (/), also known as the application's home page.

First, I'll create a new file called `hello_world.ex` in the `lib/handlers` folder. In that file I'll add my new handler module:

```
defmodule HTTPServer.Handlers.HelloWorld do
  alias HTTPServer.Request
  alias HTTPServer.Response
  @behaviour HTTPServer.Handler

  @impl HTTPServer.Handler
  def handle(%Request{method: "GET"} = _req) do
    body = "Hello World!"
    {200, body, Response.build_headers(body)}
  end
end
```

Next I'll update the `lib/routes.ex` file to include the new route and it's corresponding handler:

```
defmodule HTTPServer.Routes do
  alias HTTPServer.Handlers.HelloWorld
  
  def routes, 
    do: %{
      "/PATH" => %{
        handler: HandlerModule,
        methods: ["GET"]
      } 
    }
end
```

What if I want my app to also respond to POST requests with the request body on the homepage? I would update my HelloWorld module to look like:

```
defmodule HTTPServer.Handlers.HelloWorld do
  alias HTTPServer.Request
  @behaviour HTTPServer.Handler

  @impl HTTPServer.Handler
  def handle(%Request{method: "GET"} = _req) do
    body = "Hello World!"
    {200, body, Response.build_headers(body)}
  end
  def handle(%Request{method: "POST"} = req) do
    {200, req.body, Response.build_headers(req.body)}
  end
end
```

And finally update the `HTTPServer.Routes` module to reflect the newly added method:

```
defmodule HTTPServer.Routes do
  alias HTTPServer.Handlers.HelloWorld
  
  def routes, 
    do: %{
      "/PATH" => %{
        handler: HandlerModule,
        methods: ["GET", "POST"]
      } 
    }
end
```

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
