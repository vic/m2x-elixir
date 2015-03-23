defmodule M2X.Trigger do
  @moduledoc """
    Wrapper for the AT&T M2X Device/Distribution Triggers API.
    https://m2x.att.com/developer/documentation/v2/device
    https://m2x.att.com/developer/documentation/v2/distribution
  """
  use M2X.Subresource, path: {"/triggers", :id}

  @doc """
    Test the specified trigger by firing it with a fake value.

    https://m2x.att.com/developer/documentation/v2/device#Test-Trigger
    https://m2x.att.com/developer/documentation/v2/distribution#Test-Trigger
  """
  def test!(trigger = %M2X.Trigger { client: client }) do
    M2X.Client.post(client, path(trigger)<>"/test")
  end

end
