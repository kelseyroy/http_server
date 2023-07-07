# Serving Static Files

To serve static files such as images, CSS files, and HTML files from within a static assets directory, use the HTTPServer.ServeStatic built-in middleware. The function call to add static asset routes that correspond with files from a folder will take the following structure:

```
HTTPServer.ServeStatic.add_static_routes(%{ROUTES_MAP}, "filepath/to/dir", "/mount-path")
```

* `HTTPServer.ServeStatic` is the module that lets you serve static assets from within the directory specified by `filepath/to/dir`.
* `add_static_routes/3` is the function call that updates the routes map to include the static asset routes. It accepts a routes map, a string representing a filepath to a static assests directory and, optionally, a string representing a path to mount the static asset routes on.
* `%{ROUTES_MAP}` is a list of paths on the server that will be updated by `add_static_routes/3` to include the static asset routes. See the "Anatomy of a Route" for more information on how this map must be structured.
* `"filepath/to/dir"` specifies the stringified file tree path to the directory from which to serve static assets.
* `"/mount-path"` specifies a mount path for the static assets in the directory, creating a virtual path prefix to access and load each static asset. This is optional and if left blank will default to the `root` path.

Implementation of this middleware happens in the `HTTPServer.Routes` module in `lib/routes.ex`. For example, use the following code to serves images, HTML and CSS files saved in a directory named `public`:

```
def routes do 
  %{
    ...
  }
  |> HTTPServer.ServeStatic.add_static_routes("public", "/static")
end
```

The `public` argument specifies the directory name, and the `/static` argument specifies the path prefix.

Now you can load the files that are in the `public` using the virtual path prefix `/static`:

```
http://localhost:4000/static/kitten.jpg
http://localhost:4000/static/layout-style.css
http://localhost:4000/static/hello.html
```

To use multiple static asset directories, you can call `HTTPServer.ServeStatic.add_static_routes/3` multiple times:

```
def routes do 
  %{
    ...
  }
  |> HTTPServer.ServeStatic.add_static_routes("public")
  |> HTTPServer.ServeStatic.add_static_routes("test/public", "/test-files")
end
```
