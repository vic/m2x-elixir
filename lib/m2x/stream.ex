defmodule M2X.Stream do
  @moduledoc """
    Wrapper for the AT&T M2X Device Streams API.
    https://m2x.att.com/developer/documentation/v2/device
  """
  use M2X.Subresource, path: {"/streams", :name}, under: M2X.Device

  @doc """
    List values from the Stream matching the given optional search parameters.

    https://m2x.att.com/developer/documentation/v2/device#List-Data-Stream-Values
  """
  def values(stream = %M2X.Stream { client: client }, params\\nil) do
    M2X.Client.get(client, path(stream)<>"/values", params)
  end

  @doc """
    Sample values from the Stream matching the given optional search parameters.

    https://m2x.att.com/developer/documentation/v2/device#List-Data-Stream-Sampling
  """
  def sampling(stream = %M2X.Stream { client: client }, params\\nil) do
    M2X.Client.get(client, path(stream)<>"/sampling", params)
  end

  @doc """
    Get statistics calculated from the values of the Stream, with optional parameters.

    https://m2x.att.com/developer/documentation/v2/device#List-Data-Stream-Stats
  """
  def stats(stream = %M2X.Stream { client: client }, params\\nil) do
    M2X.Client.get(client, path(stream)<>"/stats", params)
  end

  @doc """
    Update the current value of the stream, with optional timestamp.

    https://m2x.att.com/developer/documentation/v2/device#Update-Data-Stream-Value
  """
  def update_value(stream = %M2X.Stream { client: client }, value) do
    M2X.Client.put(client, path(stream)<>"/value", %{ value: value })
  end
  def update_value(stream = %M2X.Stream { client: client }, value, timestamp) do
    M2X.Client.put(client, path(stream)<>"/value", %{ value: value, timestamp: timestamp })
  end

  @doc """
    Post a list of multiple values with timestamps to the Stream.

    https://m2x.att.com/developer/documentation/v2/device#Post-Data-Stream-Values
  """
  def post_values(stream = %M2X.Stream { client: client }, values) do
    M2X.Client.post(client, path(stream)<>"/values", %{ values: values })
  end

  @doc """
    Delete values in a Stream by a date range.

    https://m2x.att.com/developer/documentation/v2/device#Post-Data-Stream-Values
  """
  def delete_values!(stream = %M2X.Stream { client: client }, start, stop) do
    M2X.Client.delete(client, path(stream)<>"/values", %{ from: start, end: stop })
  end

end
