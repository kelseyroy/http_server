defmodule HTTPServer.Router.Handlers.UnsupportedMediaType do
  @behaviour HTTPServer.Handler

  @impl HTTPServer.Handler
  def handle(_req) do
    body = """
      <html>
        <head>
          <title>Unsupported Format<\title>
        </head>
        <body>
          <p>Please check content-type and try again</p>
        </body>
      </html>
    """

    {415, body, :html}
  end
end
