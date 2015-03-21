# Common tests for modules with M2X.Resource behaviour
defmodule M2X.SubresourceTest.Common do
  defmacro __using__(opts) do
    {:ok, mod}   = Keyword.fetch(opts, :mod)
    {:ok, under} = Keyword.fetch(opts, :under)

    quote location: :keep do
      alias unquote(mod),   as: TheModule
      alias unquote(under), as: ParentModule

      def test_attributes do
        Map.merge required_attrs,
          %{ "foo"=>88, "bar"=>"ninety-nine" }
      end

      def new_test_attributes do
        Map.merge required_attrs,
          %{ "foo"=>99, "bar"=>"eighty-eight", "baz"=>true }
      end

      def mock_subject(request, response) do
        %TheModule {
          client: MockEngine.client(request, response),
          attributes: test_attributes,
          under: under_path
        }
      end

      test "attribute access" do
        subject = %TheModule { attributes: test_attributes }

        assert subject.attributes == test_attributes
        assert subject["foo"]     == test_attributes["foo"]
        assert subject["bar"]     == test_attributes["bar"]
      end

      test "refreshed" do
        subject = mock_subject \
          {:get, path, nil},
          {200, new_test_attributes}
        assert subject.attributes == test_attributes
        new_subject = TheModule.refreshed(subject)

        %TheModule { } = new_subject
        assert new_subject.client == subject.client
        assert new_subject.attributes == new_test_attributes
      end

      test "update!" do
        subject = mock_subject \
          {:put, path, new_test_attributes},
          {204, nil}
        assert TheModule.update!(subject, new_test_attributes).success?
      end

      test "delete!" do
        subject = mock_subject \
          {:delete, path, nil},
          {204, nil}
        assert TheModule.delete!(subject).success?
      end

    end
  end
end

defmodule M2X.SubresourceTest.Stream do
  use ExUnit.Case
  use M2X.SubresourceTest.Common, mod: M2X.Stream, under: M2X.Device
  doctest M2X.Stream

  def name           do "temperature"                         end
  def device_id      do "0123456789abcdef0123456789abcdef"    end
  def under_path     do "/devices/"<>device_id                end
  def main_path      do "/v2"<>under_path<>"/streams"         end
  def path           do main_path<>"/"<>name                  end
  def required_attrs do %{ "name" => name }                   end
end
