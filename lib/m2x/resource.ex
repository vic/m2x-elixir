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

      # Query the service and return a refreshed version of the same
      # resource struct with all attributes set to their latest values.
      def refreshed(resource = %TheModule { client: client }) do
        res = M2X.Client.get(client, TheModule.path(resource))
        res.success? and %TheModule { resource | attributes: res.json }
      end

      # Update the remote resource using the given attributes.
      def update!(resource = %TheModule { client: client }, params) do
        M2X.Client.put(client, TheModule.path(resource), params)
      end

      # Delete the remote resource.
      def delete!(resource = %TheModule { client: client }) do
        M2X.Client.delete(client, TheModule.path(resource))
      end

    end
  end
end
