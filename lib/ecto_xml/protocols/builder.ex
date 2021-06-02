defprotocol EctoXml.Builder do
  @moduledoc """
  Protocol that allows building ecto schemas into documents.

  Allows mapping the field names.
  """

  @fallback_to_any true

  @spec resolve_element_name(t, atom) :: atom
  def resolve_element_name(value, key)
end

defimpl EctoXml.Builder, for: Any do
  defmacro __deriving__(_module, _struct, options) do
    map_field_names = Keyword.get(options, :map_field_names, %{})
    map_array_names = Keyword.get(options, :map_array_names, %{})

    quote do
      def resolve_element_name(value, key) do
        mapped_name =
          case value do
            _ when is_list(value) ->
              unquote(Macro.escape(map_array_names))
              |> Map.get(key)

            _ ->
              unquote(Macro.escape(map_field_names))
              |> Map.get(key)
          end

        mapped_name || key
      end

      defoverridable resolve_element_name: 2
    end
  end

  def resolve_element_name(value, _key) do
    raise Protocol.UndefinedError,
      protocol: @protocol,
      value: value,
      description: """
      EctoXml.Builder doesn't know how to build this struct.
      You can derive the implementation by specifying in the module.

      @derive {
        EctoXml.Builder,
        map_field_names: %{
          :people => :person
        },
        map_array_names: %{
          :items => :foo_items
        }
      }
      """
  end
end
