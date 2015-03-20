defmodule M2X.Device do
  @moduledoc """
    Wrapper for the AT&T M2X Device API.
    https://m2x.att.com/developer/documentation/v2/device
  """
  use M2X.Resource, main_path: "/devices"

  @doc """
    Return the API path of the given Device or id.
  """
  def path(%M2X.Device { attributes: %{ "id"=>id } }) do path(id) end
  def path(id) when is_binary(id) do @main_path<>"/"<>id end

  @doc """
    Retrieve a view of the Device associated with the given unique id.

    https://m2x.att.com/developer/documentation/v2/device#View-Device-Details
  """
  def fetch(client = %M2X.Client{}, id) do
    res = M2X.Client.get(client, path(id))
    res.success? and %M2X.Device { client: client, attributes: res.json }
  end

  @doc """
    Retrieve the list of Devices accessible by the authenticated API key that
    meet the search criteria.

    https://m2x.att.com/developer/documentation/v2/device#List-Search-Devices
  """
  def list(client = %M2X.Client{}, params\\nil) do
    res = M2X.Client.get(client, @main_path, params)
    res.success? and Enum.map res.json["devices"], fn (attributes) ->
      %M2X.Device { client: client, attributes: attributes }
    end
  end

  @doc """
    Search the catalog of public Devices.

    This allows unauthenticated users to search Devices from other users
    that have been marked as public, allowing them to read public Device
    metadata, locations, streams list, and view each Devices' stream metadata
    and its values.

    https://m2x.att.com/developer/documentation/v2/device#List-Search-Public-Devices-Catalog
  """
  def catalog(client = %M2X.Client{}, params\\nil) do
    res = M2X.Client.get(client, @main_path<>"/catalog", params)
    res.success? and Enum.map res.json["devices"], fn (attributes) ->
      %M2X.Device { client: client, attributes: attributes }
    end
  end

  @doc """
    Get location details of an existing Device.

    Note that this method can return an empty value (response status
    of 204) if the device has no location defined.

    https://m2x.att.com/developer/documentation/v2/device#Read-Device-Location
  """
  def get_location(device = %M2X.Device { client: client }) do
    M2X.Client.get(client, path(device)<>"/location")
  end

  @doc """
    Update the current location of the specified device.

    https://m2x.att.com/developer/documentation/v2/device#Update-Device-Location
  """
  def update_location(device = %M2X.Device { client: client }, params) do
    M2X.Client.put(client, path(device)<>"/location", params)
  end

  @doc """
    Post Device Updates (Multiple Values to Multiple Streams)

    This method allows posting multiple values to multiple streams
    belonging to a device and optionally, the device location.

    https://m2x.att.com/developer/documentation/v2/device#Post-Device-Updates--Multiple-Values-to-Multiple-Streams-
  """
  def post_updates(device = %M2X.Device { client: client }, params) do
    M2X.Client.post(client, path(device)<>"/updates", params)
  end

end
