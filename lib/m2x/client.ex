defmodule M2X.Client do

  @default_api_base    "https://api-m2x.att.com"
  @default_api_version :v2

  @ssl_cacertfile __DIR__ <> "/cacert.pem"

  defstruct \
    api_base:    @default_api_base,
    api_version: @default_api_version,
    api_key:     nil,
    http_engine: :hackney

  defmodule Response do
    defstruct \
      raw:           "",
      json:          %{},
      status:        0,
      headers:       %{},
      success?:      nil,
      client_error?: nil,
      server_error?: nil,
      error?:        nil
  end

  # Define REST methods for accessing the M2X API directly.
  for method <- [:get, :post, :put, :delete, :head, :options, :patch] do
    def unquote(method)(client, path, params\\%{}, headers\\%{}) do
      request(client, unquote(method), path, params, headers)
    end
  end

  ##
  # Private functions

  defp request(client, verb, path, params, headers, options\\%{}) do
    url             = make_url(client, path)
    {body, headers} = make_body(params, headers)
    header_list     = Map.to_list(headers) ++ [
      {"X-M2X-KEY", client.api_key}
    ]
    option_list     = Map.to_list(options) ++ [
      ssl_options: [{:cacertfile, @ssl_cacertfile}]
    ]

    engine = client.http_engine
    engine.start
    make_response engine,
      engine.request(verb, url, header_list, body, option_list)
  end

  defp make_response(engine, {:ok, status, header_list, body_ref}) do
    status_range = div(status, 100)
    {:ok, body}  = engine.body(body_ref)
    headers      = Enum.into(header_list, %{})
    {:ok, json}  = case headers["Content-Type"] do
                     "application/json" -> JSON.decode(body)
                     _                  -> {:ok, nil}
                   end
    %Response {
      raw:           body,
      json:          json,
      status:        status,
      headers:       headers,
      success?:      2 == status_range,
      client_error?: 4 == status_range,
      server_error?: 5 == status_range,
      error?:        4 == status_range || 5 == status_range,
    }
  end

  defp make_body(params, headers) do
    case headers["Content-Type"] do
      "application/json" ->
        {:ok, body} = JSON.encode(params)
        {body, headers}
      nil ->
        headers = Map.put(headers, "Content-Type", "application/json")
        make_body(params, headers)
    end
  end

  defp make_url(client, path) do
    case path do
      << "/"::utf8, _::binary >> -> path = path
      _                          -> path = "/" <> path
    end
    unless Regex.match?(~r"\A/v\d+/", path) do
      path = "/" <> Atom.to_string(client.api_version) <> path
    end
    client.api_base <> path
  end

end
