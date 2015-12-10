defmodule M2X.CommandTest do
  use ExUnit.Case
  doctest M2X.Command

  def mock_subject(request, response) do
    %M2X.Command {
      client: MockEngine.client(request, response),
      attributes: test_attributes,
    }
  end

  def main_url do
    "https://api-m2x.att.com/v2/commands"
  end

  def id do
    "2015120123456789abcdef0123456789abcdef"
  end

  def test_attributes do
    %{ "id"=>id, "name"=>"foo" }
  end

  test "fetch" do
    client = MockEngine.client \
      {:get, "/v2/commands/"<>id, nil},
      {200, test_attributes, nil}
    subject = M2X.Command.fetch(client, id)

    %M2X.Command { } = subject
    assert subject.client == client
    assert subject.attributes == test_attributes
  end

  test "list" do
    params = %{ q: "test" }
    <<_::binary-size(1), suffix::binary>> = id
    result = %{ commands: [
      %{ id: "a"<>suffix, name: "foo" },
      %{ id: "b"<>suffix, name: "foo" },
      %{ id: "c"<>suffix, name: "foo" },
    ]}
    client = MockEngine.client({:get, "/v2/commands", nil}, {200, result, nil})
    list   = M2X.Command.list(client)
    client = MockEngine.client({:get, "/v2/commands", params}, {200, result, nil})
    list2  = M2X.Command.list(client, params)

    for list <- [list, list2] do
      for subject = %M2X.Command{} <- list do
        assert subject.client == client
        assert subject["name"] == "foo"
      end
      assert Enum.at(list, 0)["id"] == "a"<>suffix
      assert Enum.at(list, 1)["id"] == "b"<>suffix
      assert Enum.at(list, 2)["id"] == "c"<>suffix
    end
  end

  test "send" do
    params = %{ name: "test" }
    client = MockEngine.client \
      {:post, "/v2/commands", params},
      {200, test_attributes, %{ "Location" => main_url<>"/"<>id }}
    subject = M2X.Command.send(client, params)

    %M2X.Command { } = subject
    assert subject.client == client
    assert subject.attributes == %{ "id" => id }
  end

end
