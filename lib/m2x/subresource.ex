defmodule M2X.Subresource do
  @moduledoc """
    Common behaviour module for M2X Subresources.
  """
  defmacro __using__(opts) do
    {:ok, path} = Keyword.fetch(opts, :path)
    {main_path, uid} = path
    uid = to_string(uid)

    quote location: :keep do
      defstruct \
        client: nil,
        attributes: %{},
        under: nil

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
        Return the API path of the Subresource.
      """
      def path(%TheModule { under: under, attributes: %{ unquote(uid)=>uid } }) do
        path(under, uid)
      end
      def path(under, uid) when is_binary(under) and is_binary(uid) do
        under<>@main_path<>"/"<>uid
      end

      @doc """
        Query the service and return a refreshed version of the same
        subresource struct with all attributes set to their latest values.
      """
      def refreshed(subresource = %TheModule { client: client }) do
        res = M2X.Client.get(client, TheModule.path(subresource))
        res.success? and %TheModule { subresource | attributes: res.json }
      end

      @doc """
        Update the remote subresource using the given attributes.
      """
      def update!(subresource = %TheModule { client: client }, params) do
        M2X.Client.put(client, TheModule.path(subresource), params)
      end

      @doc """
        Delete the remote subresource.
      """
      def delete!(subresource = %TheModule { client: client }) do
        M2X.Client.delete(client, TheModule.path(subresource))
      end

    end
  end
end
