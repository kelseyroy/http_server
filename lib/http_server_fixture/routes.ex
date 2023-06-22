defmodule HTTPServerFixture.Routes do
  def routes,
    do: %{
      "/echo_body" => %{
        handler: HTTPServerFixture.SimplePost,
        methods: ["POST", "OPTIONS"]
      },
      "/simple_get" => %{
        handler: HTTPServerFixture.SimpleGet,
        methods: ["GET", "HEAD", "OPTIONS"]
      },
      "/simple_get_with_body" => %{
        handler: HTTPServerFixture.SimpleGetWithBody,
        methods: ["GET", "HEAD", "OPTIONS"]
      },
      "/head_request" => %{
        handler: HTTPServerFixture.SimpleHead,
        methods: ["GET", "HEAD", "OPTIONS"]
      },
      "/method_options" => %{
        handler: HTTPServerFixture.Options,
        methods: ["GET", "HEAD", "OPTIONS"]
      },
      "/method_options2" => %{
        handler: HTTPServerFixture.OptionsTwo,
        methods: ["GET", "POST", "PUT", "HEAD", "OPTIONS"]
      }
    }
end
