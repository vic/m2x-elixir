defmodule M2X.JobTest do
  use ExUnit.Case
  doctest M2X.Job

  def mock_subject(request, response) do
    %M2X.Job {
      client: MockEngine.client(request, response),
      attributes: test_attributes,
    }
  end

  def job do
    "0123456789abcdef0123456789abcdef"
  end

  def test_attributes do
    %{ "job"=>job }
  end

  test "fetch" do
    client = MockEngine.client \
      {:get, "/v2/jobs/"<>job, nil},
      {200, test_attributes, nil}
    subject = M2X.Job.fetch(client, job)

    %M2X.Job { } = subject
    assert subject.client == client
    assert subject.attributes == test_attributes
  end

end
