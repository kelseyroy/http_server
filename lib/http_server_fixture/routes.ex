defmodule HTTPServerFixture.Routes do
  def routes,
    do: %{
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
        handler: HTTPServer.Handlers.Redirect,
        methods: ["GET"],
        location: "/simple_get"
      }
    }
end
