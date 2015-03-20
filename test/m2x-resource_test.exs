# Common tests for modules with M2X.Resource behaviour
defmodule M2X.ResourceTest.Common do
  defmacro __using__(opts) do
    {:ok, mod} = Keyword.fetch(opts, :mod)

    quote location: :keep do
      alias unquote(mod), as: TheModule

      def test_attributes do
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

defmodule M2X.ResourceTest.Device do
  use ExUnit.Case
  use M2X.ResourceTest.Common, mod: M2X.Device
  doctest M2X.Device
end
