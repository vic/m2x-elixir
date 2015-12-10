# Common tests for modules with M2X.BareResource behaviour
defmodule M2X.BareResourceTest.Common do
  defmacro __using__(opts) do
    {:ok, mod} = Keyword.fetch(opts, :mod)

    quote location: :keep do
      alias unquote(mod), as: TheModule

      def test_attributes do
        Map.merge required_attrs,
          %{ "foo"=>88, "bar"=>"ninety-nine" }
      end

      test "attribute access" do
        subject = %TheModule { attributes: test_attributes }

        assert subject.attributes == test_attributes
        assert subject["foo"]     == test_attributes["foo"]
        assert subject["bar"]     == test_attributes["bar"]
      end

    end
  end
end
