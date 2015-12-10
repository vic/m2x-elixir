defmodule M2X.BareResource do
  @moduledoc """
    Common behaviour module for modules that aren't full M2X Resources.
  """
  defmacro __using__(opts) do
    {:ok, path} = Keyword.fetch(opts, :path)
    {main_path, _} = path

    quote location: :keep do
      defstruct \
        client: nil,
        attributes: %{}

      alias __MODULE__, as: TheModule

      # Implement Access protocol to delegate struct[key] to struct.attributes[key]
      defimpl Access, for: TheModule do
        def get(%TheModule { attributes: attributes }, key) do
          Map.get(attributes, key)
        end
        def get_and_update(%TheModule { attributes: attributes }, key, fun) do
          current_value = Map.get(attributes, key)
          {get, update} = fun.(current_value)
          {get, Map.put(key, update, attributes)}
        end
      end

      @main_path unquote(main_path)

    end
  end
end
