defmodule M2X.TriggerTest do
  use ExUnit.Case
  doctest M2X.Trigger

  def mock_subject(request, response) do
    %M2X.Trigger {
      client: MockEngine.client(request, response),
      attributes: test_attributes,
      under: "/devices/"<>device_id,
    }
  end

  def id              do "high temperature"                    end
  def device_id       do "0123456789abcdef0123456789abcdef"    end
  def test_attributes do
    %{ "id"=>id, "stream"=>"temperature", "condition"=>">", "value"=>30 }
  end

  test "test!" do
    subject = mock_subject \
      {:post, "/v2/devices/"<>device_id<>"/triggers/"<>id<>"/test", nil},
      {204, nil}
    assert M2X.Trigger.test!(subject).success?
  end

end
