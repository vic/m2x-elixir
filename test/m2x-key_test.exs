defmodule M2X.KeyTest do
  use ExUnit.Case
  doctest M2X.Key

  def mock_subject(request, response) do
    %M2X.Key {
      client: MockEngine.client(request, response),
      attributes: test_attributes,
    }
  end

  def key do
    "0123456789abcdef0123456789abcdef"
  end

  def test_attributes do
    %{ "key"=>key, "name"=>"test", "master"=>false }
  end

  test "fetch" do
    client = MockEngine.client \
      {:get, "/v2/keys/"<>key, nil},
      {200, test_attributes, nil}
    subject = M2X.Key.fetch(client, key)

    %M2X.Key { } = subject
    assert subject.client == client
    assert subject.attributes == test_attributes
  end

  test "list" do
    params = %{ q: "test" }
    <<_::binary-size(1), suffix::binary>> = key
    result = %{ keys: [
      %{ key: "a"<>suffix, name: "test", master: true },
      %{ key: "b"<>suffix, name: "test", master: false },
      %{ key: "c"<>suffix, name: "test", master: false },
    ]}
    client = MockEngine.client({:get, "/v2/keys", nil}, {200, result, nil})
    list   = M2X.Key.list(client)
    client = MockEngine.client({:get, "/v2/keys", params}, {200, result, nil})
    list2  = M2X.Key.list(client, params)

    for list <- [list, list2] do
      for subject = %M2X.Key{} <- list do
        assert subject.client == client
        assert subject["name"] == "test"
      end
      assert Enum.at(list, 0)["key"] == "a"<>suffix
      assert Enum.at(list, 1)["key"] == "b"<>suffix
      assert Enum.at(list, 2)["key"] == "c"<>suffix
    end
  end

  test "regenerated" do
    new_test_attributes = %{ test_attributes | "key"=>String.reverse(key) }
    subject = mock_subject \
      {:get, "/v2/keys/"<>key, nil},
      {200, new_test_attributes, nil}
    assert subject.attributes == test_attributes
    new_subject = M2X.Key.regenerated(subject)

    %M2X.Key { } = new_subject
    assert new_subject.client == subject.client
    assert new_subject.attributes == new_test_attributes
  end

end
