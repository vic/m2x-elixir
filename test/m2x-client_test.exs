defmodule M2X.ClientTest do
  use ExUnit.Case
  doctest M2X.Client

  test "default struct values" do
    subject = %M2X.Client { }
    assert subject.api_base    == "https://api-m2x.att.com"
    assert subject.api_version == :v2
    assert subject.api_key     == nil
  end

  def subject do
    %M2X.Client { api_key: "0123456789abcdef0123456789abcdef" }
  end

  test "get" do
    assert M2X.Client.get(subject, "/status").success?
  end

end
