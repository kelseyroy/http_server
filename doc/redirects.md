# Handling Redirects

Luckily, the server already has built in middleware to accomodate URL redirection/forwarding responses! Redirects allow a user to preserve an existing path while assigning it a new and premanent endpoint. All necessary changes needed to setup URI redirection happen in the `HTTPServer.Routes` module in `lib/routes.ex`:

```
def routes do 
  %{
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
end
```

* `/FROM` is the original path on the server you are redirecting the client away from. This path will respond to the HTTP Client with a 301 status code, which will send the request to the path specified in the `location:` field.
* `HTTPServer.Handlers.Redirect` is the module that lets you redirect the user to a different URL by sending an HTTP response with status 301.
* `methods: ["METHOD"]` is a list of [HTTP request methods](https://en.wikipedia.org/wiki/HTTP#Request_methods) that the `/TO` path can respond to.
* `location: "/TO"` is the path on the server you are redirecting the client towards. After receiving a response with a 301 status code at the `/FROM` endpoint, the `Location` response header will point toward this path as the new endpoint that will respond to the request.

Please be sure that the `/TO` route and it's handler module is properly setup before redirecting the clients to that path.
