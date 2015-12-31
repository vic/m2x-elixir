defmodule M2X.Collection do
  @moduledoc """
    Wrapper for the AT&T M2X Collection API.
    https://m2x.att.com/developer/documentation/v2/collections
  """
  use M2X.Resource, path: {"/collections", :id}

  @doc """
    Retrieve a view of the Collection associated with the given unique id.

    https://m2x.att.com/developer/documentation/v2/collections#View-Collection-Details
  """
  def fetch(client = %M2X.Client{}, id) do
    res = M2X.Client.get(client, path(id))
    res.success? and %M2X.Collection { client: client, attributes: res.json }
  end

  @doc """
    Get the custom metadata for the specified Collection.

    https://m2x.att.com/developer/documentation/v2/collections#Read-Collection-Metadata
  """
  def metadata(coll = %M2X.Collection { client: client }) do
    M2X.Client.get(client, path(coll)<>"/metadata")
  end

  @doc """
    Update the custom metadata for the specified Collection.

    https://m2x.att.com/developer/documentation/v2/collections#Update-Collection-Metadata
  """
  def update_metadata(coll = %M2X.Collection { client: client }, params) do
    M2X.Client.put(client, path(coll)<>"/metadata", params)
  end

  @doc """
    Get the custom metadata for the specified Collection.

    https://m2x.att.com/developer/documentation/v2/collections#Read-Collection-Metadata-Field
  """
  def get_metadata_field(coll = %M2X.Collection { client: client }, name) do
    M2X.Client.get(client, path(coll)<>"/metadata/"<>name)
  end

  @doc """
    Update the custom metadata for the specified Collection.

    https://m2x.att.com/developer/documentation/v2/collections#Update-Collection-Metadata-Field
  """
  def set_metadata_field(coll = %M2X.Collection { client: client }, name, value) do
    M2X.Client.put(client, path(coll)<>"/metadata/"<>name, %{ "value" => value })
  end

  @doc """
    Retrieve the list of Collections accessible by the authenticated API key
    that meet the search criteria.

    https://m2x.att.com/developer/documentation/v2/collections#List-collections
  """
  def list(client = %M2X.Client{}, params\\nil) do
    res = M2X.Client.get(client, @main_path, params)
    res.success? and Enum.map res.json["collections"], fn (attributes) ->
      %M2X.Collection { client: client, attributes: attributes }
    end
  end

end
