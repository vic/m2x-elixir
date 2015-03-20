defmodule M2X.Key do
  use M2X.Resource, main_path: "/keys"

  def path(%M2X.Key { attributes: %{ "key"=>key } }) do path(key) end
  def path(key) when is_binary(key) do @main_path<>"/"<>key end

  ##
  # Module functions

  # Retrieve a view of the Key associated with the given unique key string.
  #
  # https://m2x.att.com/developer/documentation/v2/keys#View-Key-Details
  def fetch(client = %M2X.Client{}, key) do
    res = M2X.Client.get(client, path(key))
    res.success? and %M2X.Key { client: client, attributes: res.json }
  end

  # Retrieve the list of keys associated with the specified account that
  # meet the search criteria.
  #
  # https://m2x.att.com/developer/documentation/v2/keys#List-Keys
  def list(client = %M2X.Client{}, params\\nil) do
    res = M2X.Client.get(client, @main_path, params)
    res.success? and Enum.map res.json["keys"], fn (attributes) ->
      %M2X.Key { client: client, attributes: attributes }
    end
  end

  ##
  # Module functions

  # Regenerate an API Key token and return the regenerated Key.
  #
  # Note that if you regenerate the key that you're using for
  # authentication then you would need to change your scripts to
  # start using the new key token for all subsequent requests.
  #
  # https://m2x.att.com/developer/documentation/v2/keys#Regenerate-Key
  def regenerated(key = %M2X.Key { client: client }) do
    res = M2X.Client.get(client, M2X.Key.path(key))
    res.success? and %M2X.Key { key | attributes: res.json }
  end
end