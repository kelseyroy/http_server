defmodule HTTPServerFixture.Routes do
  def routes,
    do: %{
      "/echo_body" => HTTPServerFixture.SimplePost,
      "/simple_get" => HTTPServerFixture.SimpleGet,
      "/simple_get_with_body" => HTTPServerFixture.SimpleGetWithBody,
      "/head_request" => HTTPServerFixture.SimpleHead,
      "/method_options" => HTTPServerFixture.Options,
      "/method_options2" => HTTPServerFixture.OptionsTwo
    }
end
