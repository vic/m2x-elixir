defmodule M2X.DeviceTest do
  use ExUnit.Case
  doctest M2X.Device

  def mock_subject(request, response) do
    %M2X.Device {
      client: MockEngine.client(request, response),
      attributes: test_attributes,
    }
  end

  def id do
    "0123456789abcdef0123456789abcdef"
  end

  def test_attributes do
    %{ "id"=>id, "name"=>"test", "visibility"=>"public", "description"=>"foo" }
  end

  def test_location do
    %{ "latitude"=>-37.978842356, "longitude"=>-57.547877691, "elevation"=>5 }
  end

  test "fetch" do
    client = MockEngine.client \
      {:get, "/v2/devices/"<>id, nil},
      {200, test_attributes}
    subject = M2X.Device.fetch(client, id)

    %M2X.Device { } = subject
    assert subject.client == client
    assert subject.attributes == test_attributes
  end

  test "list, catalog" do
    params = %{ q: "test" }
    <<_::binary-size(1), suffix::binary>> = id
    result = %{ devices: [
      %{ id: "a"<>suffix, name: "test", description: "foo" },
      %{ id: "b"<>suffix, name: "test", description: "bar" },
      %{ id: "c"<>suffix, name: "test", description: "baz" },
    ]}
    client   = MockEngine.client({:get, "/v2/devices", nil}, {200, result})
    list     = M2X.Device.list(client)
    client   = MockEngine.client({:get, "/v2/devices/catalog", nil}, {200, result})
    catalog  = M2X.Device.catalog(client)
    client   = MockEngine.client({:get, "/v2/devices", params}, {200, result})
    list2    = M2X.Device.list(client, params)
    client   = MockEngine.client({:get, "/v2/devices/catalog", params}, {200, result})
    catalog2 = M2X.Device.catalog(client, params)

    for list <- [list, catalog, list2, catalog2] do
      for subject = %M2X.Device{} <- list do
        assert subject.client == client
        assert subject["name"] == "test"
      end
      assert Enum.at(list, 0)["id"] == "a"<>suffix
      assert Enum.at(list, 1)["id"] == "b"<>suffix
      assert Enum.at(list, 2)["id"] == "c"<>suffix
    end
  end

  test "get_location" do
    subject = mock_subject \
      {:get, "/v2/devices/"<>id<>"/location", nil},
      {200, test_location}

    assert M2X.Device.get_location(subject).json == test_location
  end

  test "update_location" do
    subject = mock_subject \
      {:put, "/v2/devices/"<>id<>"/location", test_location},
      {202, nil}

    assert M2X.Device.update_location(subject, test_location).status == 202
  end

  test "post_updates" do
    params = %{ values: %{
      temperature: [
        %{ timestamp: "2014-09-09T19:15:00.981Z", "value": 32 },
        %{ timestamp: "2014-09-09T20:15:00.124Z", "value": 30 },
        %{ timestamp: "2014-09-09T21:15:00.124Z", "value": 15 } ],
      humidity: [
        %{ timestamp: "2014-09-09T19:15:00.874Z", "value": 88 },
        %{ timestamp: "2014-09-09T20:15:00.752Z", "value": 60 },
        %{ timestamp: "2014-09-09T21:15:00.752Z", "value": 75 } ]
    }}
    subject = mock_subject \
      {:post, "/v2/devices/"<>id<>"/updates", params},
      {202, nil}

    assert M2X.Device.post_updates(subject, params).status == 202
  end

end
