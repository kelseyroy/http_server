defmodule HTTPServerFixture.Routes do
  def routes,
    do: %{
      "/echo_body" => &HTTPServerFixture.SimplePost.handle/1,
      "/simple_get" => &HTTPServerFixture.SimpleGet.handle/1,
      "/simple_get_with_body" => &HTTPServerFixture.SimpleGetWithBody.handle/1,
      "/head_request" => &HTTPServerFixture.SimpleHead.handle/1
    }
end
