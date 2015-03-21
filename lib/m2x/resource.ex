defmodule M2X.Resource do
  @moduledoc """
    Common behaviour module for M2X Resources.
  """
  defmacro __using__(opts) do
    {:ok, path} = Keyword.fetch(opts, :path)
    {main_path, uid} = path
    uid = to_string(uid)

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

      @doc """
        Return the API path of the Resource.
      """
      def path(%TheModule { attributes: %{ unquote(uid)=>uid } }) do
        path(uid)
      end
      def path(uid) when is_binary(uid) do
        @main_path<>"/"<>uid
      end

      @doc """
        Create a new resource using the given client and optional params,
        returning a struct with the attributes of the new resource.
      """
      def create!(client = %M2X.Client{}, params\\%{}) do
        res = M2X.Client.post(client, @main_path, params)
        res.success? and %TheModule { client: client, attributes: res.json }
      end

      @doc """
        Query the service and return a refreshed version of the same
        resource struct with all attributes set to their latest values.
      """
      def refreshed(resource = %TheModule { client: client }) do
        res = M2X.Client.get(client, TheModule.path(resource))
        res.success? and %TheModule { resource | attributes: res.json }
      end

      @doc """
        Update the remote resource using the given attributes.
      """
      def update!(resource = %TheModule { client: client }, params) do
        M2X.Client.put(client, TheModule.path(resource), params)
      end

      @doc """
        Delete the remote resource.
      """
      def delete!(resource = %TheModule { client: client }) do
        M2X.Client.delete(client, TheModule.path(resource))
      end

    end
  end
end
