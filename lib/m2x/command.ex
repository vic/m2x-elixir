defmodule M2X.Command do
  @moduledoc """
    Wrapper for the AT&T M2X Commands API.
    https://m2x.att.com/developer/documentation/v2/jobs
  """
  use M2X.BareResource, path: {"/commands", :id}

  @doc """
    Return the API path of the Command.
  """
  def path(%M2X.Command { attributes: %{ "id" => uid } }) do
    path(uid)
  end
  def path(uid) when is_binary(uid) do
    @main_path<>"/"<>uid
  end

  @doc """
    Retrieve the list of Commands accessible by the authenticated API key.

    https://m2x.att.com/developer/documentation/v2/commands#List-Commands
  """
  def list(client = %M2X.Client{}, params\\nil) do
    res = M2X.Client.get(client, @main_path, params)
    res.success? and Enum.map res.json["commands"], fn (attributes) ->
      %M2X.Command { client: client, attributes: attributes }
    end
  end

  @doc """
    Retrieve a view of the Command associated with the given command id.

    https://m2x.att.com/developer/documentation/v2/commands#View-Command-Details
  """
  def fetch(client = %M2X.Client{}, id) do
    res = M2X.Client.get(client, path(id))
    res.success? and %M2X.Command { client: client, attributes: res.json }
  end

  @doc """
    Send a Command with the given name and data to the given targets.

    https://m2x.att.com/developer/documentation/v2/commands#Send-Command
  """
  def send(client = %M2X.Client{}, params) do
    res = M2X.Client.post(client, @main_path, params)
    case Map.fetch(res.headers, "Location") do
      {:ok, location} ->
        uid = List.last(String.split(location, "/"))
        %M2X.Command { client: client, attributes: %{ "id" => uid } }
      _ -> false
    end
  end

end
