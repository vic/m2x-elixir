defmodule M2X.Distribution do
  use M2X.Resource, main_path: "/distributions"

  def path(%M2X.Distribution { attributes: %{ "id"=>id } }) do path(id) end
  def path(id) when is_binary(id) do @main_path<>"/"<>id end

  ##
  # Module functions

  # Retrieve a view of the Distribution associated with the given unique id.
  #
  # https://m2x.att.com/developer/documentation/v2/distribution#View-Distribution-Details
  def fetch(client = %M2X.Client{}, id) do
    res = M2X.Client.get(client, path(id))
    res.success? and %M2X.Distribution { client: client, attributes: res.json }
  end

  # Retrieve the list of Distributions accessible by the authenticated API key
  # that meet the search criteria.
  #
  # https://m2x.att.com/developer/documentation/v2/distribution#List-Search-Distributions
  def list(client = %M2X.Client{}, params\\nil) do
    res = M2X.Client.get(client, @main_path, params)
    res.success? and Enum.map res.json["distributions"], fn (attributes) ->
      %M2X.Distribution { client: client, attributes: attributes }
    end
  end

  ##
  # Struct functions

  # Retrieve list of Devices added to the specified Distribution.
  #
  # https://m2x.att.com/developer/documentation/v2/distribution#List-Devices-from-an-existing-Distribution
  def devices(dist = %M2X.Distribution{ client: client }, params\\nil) do
    res = M2X.Client.get(client, path(dist)<>"/devices", params)
    res.success? and Enum.map res.json["devices"], fn (attributes) ->
      %M2X.Device { client: client, attributes: attributes }
    end
  end

  # Add a new Device to the Distribution, with the given unique serial string.
  #
  # https://m2x.att.com/developer/documentation/v2/distribution#Add-Device-to-an-existing-Distribution
  def add_device(dist = %M2X.Distribution{ client: client }, serial) do
    params = %{ serial: serial }
    res = M2X.Client.post(client, path(dist)<>"/devices", params)
    res.success? and %M2X.Device { client: client, attributes: res.json }
  end

end
