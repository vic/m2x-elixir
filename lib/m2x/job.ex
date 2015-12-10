defmodule M2X.Job do
  @moduledoc """
    Wrapper for the AT&T M2X Jobs API.
    https://m2x.att.com/developer/documentation/v2/jobs
  """
  use M2X.BareResource, path: {"/jobs", :job}

  @doc """
    Return the API path of the Resource.
  """
  def path(%M2X.Job { attributes: %{ :job => uid } }) do
    path(uid)
  end
  def path(uid) when is_binary(uid) do
    @main_path<>"/"<>uid
  end

  @doc """
    Retrieve a view of the Job associated with the given unique job id.

    https://m2x.att.com/developer/documentation/v2/jobs#View-Job-Details
  """
  def fetch(client = %M2X.Client{}, job) do
    res = M2X.Client.get(client, path(job))
    res.success? and %M2X.Job { client: client, attributes: res.json }
  end

end
