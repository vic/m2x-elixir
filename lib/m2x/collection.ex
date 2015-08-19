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
