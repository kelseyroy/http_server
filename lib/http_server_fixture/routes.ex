defmodule HTTPServerFixture.Routes do
  alias HTTPServer.ServeStatic

  def routes do
    %{
      "/echo_body" => %{
        handler: HTTPServerFixture.SimplePost,
        methods: ["POST"]
      },
      "/simple_get" => %{
        handler: HTTPServerFixture.SimpleGet,
        methods: ["GET"]
      },
      "/simple_get_with_body" => %{
        handler: HTTPServerFixture.SimpleGetWithBody,
        methods: ["GET"]
      },
      "/head_request" => %{
        handler: HTTPServerFixture.SimpleHead,
        methods: ["GET"]
      },
      "/method_options" => %{
        handler: HTTPServerFixture.Options,
        methods: ["GET"]
      },
      "/method_options2" => %{
        handler: HTTPServerFixture.OptionsTwo,
        methods: ["GET", "POST", "PUT"]
      },
      "/redirect" => %{
        handler: HTTPServer.Router.Handlers.Redirect,
        methods: ["GET"],
        location: "/simple_get"
      },
      "/text_response" => %{
        handler: HTTPServerFixture.TextResponse,
        methods: ["GET"]
      },
      "/html_response" => %{
        handler: HTTPServerFixture.HTMLResponse,
        methods: ["GET"]
      },
      "/json_response" => %{
        handler: HTTPServerFixture.JSONResponse,
        methods: ["GET"]
      },
      "/xml_response" => %{
        handler: HTTPServerFixture.XMLResponse,
        methods: ["GET"]
      },
      "/todo" => %{
        handler: ToDo.Handlers.ToDo,
        methods: ["POST", "DELETE", "PUT"]
      }
    }
    |> ServeStatic.add_static_routes("test/http_server_spec/web")
  end
end
