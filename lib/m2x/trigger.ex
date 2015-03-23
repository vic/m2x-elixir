defmodule M2X.Trigger do
  @moduledoc """
    Wrapper for the AT&T M2X Device/Distribution Triggers API.
    https://m2x.att.com/developer/documentation/v2/device
    https://m2x.att.com/developer/documentation/v2/distribution
  """
  use M2X.Subresource, path: {"/triggers", :id}

end
