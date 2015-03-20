# Common behaviour module for M2X Resources
defmodule M2X.Resource do
  defmacro __using__(_opts) do
    quote location: :keep do

      defstruct \
        client:     nil,
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

    end
  end
end
