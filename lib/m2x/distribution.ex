defmodule M2X.Distribution do
  @moduledoc """
    Wrapper for the AT&T M2X Distribution API.
    https://m2x.att.com/developer/documentation/v2/distribution
  """
  use M2X.Resource, path: {"/distributions", :id}

  @doc """
    Retrieve a view of the Distribution associated with the given unique id.

    https://m2x.att.com/developer/documentation/v2/distribution#View-Distribution-Details
  """
  def fetch(client = %M2X.Client{}, id) do
    res = M2X.Client.get(client, path(id))
    res.success? and %M2X.Distribution { client: client, attributes: res.json }
  end

  @doc """
    Get the custom metadata for the specified Distribution.

    https://m2x.att.com/developer/documentation/v2/distribution#Read-Distribution-Metadata
  """
  def metadata(dist = %M2X.Distribution { client: client }) do
    M2X.Client.get(client, path(dist)<>"/metadata")
  end

  @doc """
    Update the custom metadata for the specified Distribution.

    https://m2x.att.com/developer/documentation/v2/distribution#Update-Distribution-Metadata
  """
  def update_metadata(dist = %M2X.Distribution { client: client }, params) do
    M2X.Client.put(client, path(dist)<>"/metadata", params)
  end

  @doc """
    Get the custom metadata for the specified Distribution.

    https://m2x.att.com/developer/documentation/v2/distribution#Read-Distribution-Metadata-Field
  """
  def get_metadata_field(dist = %M2X.Distribution { client: client }, name) do
    M2X.Client.get(client, path(dist)<>"/metadata/"<>name)
  end

  @doc """
    Update the custom metadata for the specified Distribution.

    https://m2x.att.com/developer/documentation/v2/distribution#Update-Distribution-Metadata-Field
  """
  def set_metadata_field(dist = %M2X.Distribution { client: client }, name, value) do
    M2X.Client.put(client, path(dist)<>"/metadata/"<>name, %{ "value" => value })
  end

  @doc """
    Retrieve the list of Distributions accessible by the authenticated API key
    that meet the search criteria.

    https://m2x.att.com/developer/documentation/v2/distribution#List-Search-Distributions
  """
  def list(client = %M2X.Client{}, params\\nil) do
    res = M2X.Client.get(client, @main_path, params)
    res.success? and Enum.map res.json["distributions"], fn (attributes) ->
      %M2X.Distribution { client: client, attributes: attributes }
    end
  end

  @doc """
    Retrieve list of Devices added to the specified Distribution.

    https://m2x.att.com/developer/documentation/v2/distribution#List-Devices-from-an-existing-Distribution
  """
  def devices(dist = %M2X.Distribution{ client: client }, params\\nil) do
    res = M2X.Client.get(client, path(dist)<>"/devices", params)
    res.success? and Enum.map res.json["devices"], fn (attributes) ->
      %M2X.Device { client: client, attributes: attributes }
    end
  end

  @doc """
    Add a new Device to the Distribution, with the given unique serial string.

    https://m2x.att.com/developer/documentation/v2/distribution#Add-Device-to-an-existing-Distribution
  """
  def add_device(dist = %M2X.Distribution{ client: client }, serial) do
    params = %{ serial: serial }
    res = M2X.Client.post(client, path(dist)<>"/devices", params)
    res.success? and %M2X.Device { client: client, attributes: res.json }
  end

end
