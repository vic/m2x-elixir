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

defmodule M2X.BareResourceTest.Job do
  use ExUnit.Case
  use M2X.BareResourceTest.Common, mod: M2X.Job
  doctest M2X.Job

  def id             do "0123456789abcdef0123456789abcdef" end
  def main_path      do "/v2/jobs"                         end
  def path           do main_path<>"/"<>id                 end
  def required_attrs do %{ "id" => id }                    end
end
