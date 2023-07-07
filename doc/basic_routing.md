# Basic Routing

Right now, all requests sent to the server should receive a response back with a status code of `404`, or `NOT FOUND`. This is because the HTTP Server's routing has not yet been set up! Routing refers to the functionality of how an application handles and ultimately responds to a request at a particular endpoint. The endpoint is determined by the Path (also known as a URI) and HTTP request method (GET, POST, HEAD, DELETE, OPTIONS, etc.) passed to the application in the request. It's up to you to customize the routes you want your application to accept and the handler functions that determine what actions the application should take when the route is matched. 

## Anatomy of a Route Method:

Each route takes the following structure:

```
def routes do
  %{
    "/PATH" => %{
        handler: HandlerModule,
        methods: ["METHOD"]
      }
  }
end
```

* `routes/0` is the method that holds the routes in a Map data structure. The server path acts as the routes key, with the handler functionality as the value.
* `/PATH` is a path on the server.
* `HandlerModule` is the module that is executed when the route is matched.
* `methods: ["METHOD"]` is a list of [HTTP request method](https://en.wikipedia.org/wiki/HTTP#Request_methods) that the path can respond to. The methods are represented as a string in all capital letters. Possible methods you can include are: ["GET", "POST", "PUT", "DELETE"]. "HEAD" and "OPTIONS" methods should not be specified, as their functionality is already handled by the server itself.

It's important to note that any custom routes you create should be added to the existing `routes/0` map in the `HTTPServer.Routes` module in `lib/routes.ex`. It can also be helpful to setup the full name of your `HandlerModule` as an `alias/2` at the top of the `HTTPServer.Routes` module, but that's not strictly necessary.

## Anatomy of a Handler Method:

The application's handlers are housed in the `lib/handlers` folder. Each handler module takes the following structure:

```
defmodule HTTPServer.Handlers.MODULE_NAME do
  alias HTTPServer.Request
  @behaviour HTTPServer.Handler

  @impl HTTPServer.Handler
  def handle(%Request{method: METHOD} = req) do
    {STATUS_CODE, RESPONSE_BODY, :MEDIA_TYPE}
  end
end
```

* `MODULE_NAME` is the custom name of your handler module, which is extension of `HTTPServer.Handlers`. The module name is written in camel case and must match the text in the file name, which is written in snake case.
* `handle/1` is the method that is executed when the route is matched. It accepts a request object and pattern matches on the specified method. There can be multiple `handle/1` functions in the same handler module so long as the `METHOD` is different.
* `req` is a variable that represents the Request object. If the variable is not meant to be used, you must prefix it with an underscore.
* `METHOD` is an [HTTP request method](https://en.wikipedia.org/wiki/HTTP#Request_methods) as a string in all capital letters.
* `STATUS_CODE` is an [HTTP response status code](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes) as an integer.
* `RESPONSE_BODY` is the body of the response object that will be sent back to the client.
* `:MEDIA_TYPE` is [a media type, also known as a MIME type](https://datatracker.ietf.org/doc/html/rfc6838), represented as an Elixir atom, that indicates the nature and format of the body or file being sent back to the client. Usable media types include:
  1. `:text` for string/text-only data
  2. `:json` for JSON data
  3. `:html` for HTML content
  4. `:xml` for XML content or in an instance when you want to utilize XML's strict parsing rules
  5. `:css` for CSS files/content used to style a Web page
  6. `:png`, `:gif` and `.jpeg` for image file types such as PNGs, GIFs and JPEG/JPGs, respectively.

# An Example

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
    {200, body, :text}
  end
end
```

Next I'll update the `lib/routes.ex` file to include the new route and it's corresponding handler:

```
defmodule HTTPServer.Routes do
  alias HTTPServer.Handlers.HelloWorld
  
  def routes do 
    %{
      "/PATH" => %{
        handler: HandlerModule,
        methods: ["GET"]
      } 
    }
  end
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
    {200, body, :text}
  end
  def handle(%Request{method: "POST"} = req) do
    {200, req.body, :text}
  end
end
```

And finally update the `HTTPServer.Routes` module to reflect the newly added method:

```
defmodule HTTPServer.Routes do
  alias HTTPServer.Handlers.HelloWorld
  
  def routes do 
    %{
      "/PATH" => %{
        handler: HandlerModule,
        methods: ["GET", "POST"]
      } 
    }
  end
end
```
