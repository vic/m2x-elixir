defmodule M2X.StreamTest do
  use ExUnit.Case
  doctest M2X.Stream

  def mock_subject(request, response) do
    %M2X.Stream {
      client: MockEngine.client(request, response),
      attributes: test_attributes,
      under: "/devices/"<>device_id,
    }
  end

  def name            do "temperature"                         end
  def device_id       do "0123456789abcdef0123456789abcdef"    end
  def test_attributes do
    %{ "name"=>name, "type"=>"numeric" }
  end

  def test_list do
    [ %{ "timestamp"=>"2014-09-09T19:15:00.981Z", "value"=>32 },
      %{ "timestamp"=>"2014-09-09T20:15:00.124Z", "value"=>30 },
      %{ "timestamp"=>"2014-09-09T21:15:00.124Z", "value"=>15 } ]
  end

  def test_value_only do
    %{ "value"=>32 }
  end

  def test_value_timed do
    %{ "timestamp"=>"2014-09-09T19:15:00.981Z", "value"=>32 }
  end

  test "values/1" do
    subject = mock_subject \
      {:get, "/v2/devices/"<>device_id<>"/streams/"<>name<>"/values", nil},
      {200, %{ "values" => test_list }, nil}
    assert M2X.Stream.values(subject).json["values"] == test_list
  end

  test "values/2" do
    subject = mock_subject \
      {:get, "/v2/devices/"<>device_id<>"/streams/"<>name<>"/values", test_attributes},
      {200, %{ "values" => test_list }, nil}
    assert M2X.Stream.values(subject, test_attributes).json["values"] == test_list
  end

  test "sampling/1" do
    subject = mock_subject \
      {:get, "/v2/devices/"<>device_id<>"/streams/"<>name<>"/sampling", nil},
      {200, %{ "sampling" => test_list }, nil}
    assert M2X.Stream.sampling(subject).json["sampling"] == test_list
  end

  test "sampling/2" do
    subject = mock_subject \
      {:get, "/v2/devices/"<>device_id<>"/streams/"<>name<>"/sampling", test_attributes},
      {200, %{ "sampling" => test_list }, nil}
    assert M2X.Stream.sampling(subject, test_attributes).json["sampling"] == test_list
  end

  test "stats/1" do
    subject = mock_subject \
      {:get, "/v2/devices/"<>device_id<>"/streams/"<>name<>"/stats", nil},
      {200, %{ "stats" => test_list }, nil}
    assert M2X.Stream.stats(subject).json["stats"] == test_list
  end

  test "stats/2" do
    subject = mock_subject \
      {:get, "/v2/devices/"<>device_id<>"/streams/"<>name<>"/stats", test_attributes},
      {200, %{ "stats" => test_list }, nil}
    assert M2X.Stream.stats(subject, test_attributes).json["stats"] == test_list
  end

  test "update_value/1" do
    value = test_value_only["value"]
    subject = mock_subject \
      {:put, "/v2/devices/"<>device_id<>"/streams/"<>name<>"/value", test_value_only},
      {202, nil, nil}
    assert M2X.Stream.update_value(subject, value).success?
  end

  test "update_value/2" do
    {value, timestamp} = {test_value_timed["value"], test_value_timed["timestamp"]}
    subject = mock_subject \
      {:put, "/v2/devices/"<>device_id<>"/streams/"<>name<>"/value", test_value_timed},
      {202, nil, nil}
    assert M2X.Stream.update_value(subject, value, timestamp).success?
  end

  test "post_values" do
    subject = mock_subject \
      {:post, "/v2/devices/"<>device_id<>"/streams/"<>name<>"/values", %{ "values"=>test_list }},
      {202, nil, nil}
    assert M2X.Stream.post_values(subject, test_list).success?
  end

  test "delete_values!" do
    {start, stop} = {"2014-09-09T19:15:00.624Z", "2014-09-09T20:15:00.522Z"}
    subject = mock_subject \
      {:delete, "/v2/devices/"<>device_id<>"/streams/"<>name<>"/values", %{ "from"=>start, "end"=>stop }},
      {204, nil, nil}
    assert M2X.Stream.delete_values!(subject, start, stop).success?
  end

end
