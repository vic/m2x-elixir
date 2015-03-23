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

  @doc """
    Retrieve list of Triggers associated with the specified Distribution.

    https://m2x.att.com/developer/documentation/v2/distribution#List-Triggers
  """
  def triggers(dist = %M2X.Distribution { client: client }) do
    res = M2X.Client.get(client, path(dist)<>"/triggers")
    res.success? and Enum.map res.json["triggers"], fn (attributes) ->
      %M2X.Trigger { client: client, attributes: attributes, under: path(dist) }
    end
  end

  @doc """
    Get details of a specific Trigger associated with the Distribution.

    https://m2x.att.com/developer/documentation/v2/distribution#View-Trigger
  """
  def trigger(dist = %M2X.Distribution { client: client }, id) do
    M2X.Trigger.refreshed %M2X.Trigger {
      client: client, under: path(dist), attributes: %{ "id"=>id }
    }
  end

  @doc """
    Create a new Trigger with the given parameters associated with the Distribution.

    https://m2x.att.com/developer/documentation/v2/distribution#Create-Trigger
  """
  def create_trigger(dist = %M2X.Distribution { client: client }, params) do
    res = M2X.Client.post(client, path(dist)<>"/triggers", params)
    res.success? and %M2X.Trigger { client: client, attributes: res.json, under: path(dist) }
  end

end
