defmodule EctoXml.BuildHelper do
  @moduledoc """
  Build helper functions for EctoXml.
  """

  import XmlBuilder

  alias EctoXml.ValueResolver

  @ignored_keys [
    :__cardinality__,
    :__struct__,
    :__field__,
    :__owner__,
    :__info__,
    :__meta__
  ]

  @doc """
  Builds a list of XML elements for a given ecto schema.
  """
  @spec build_xml_elements(map, module) :: list(tuple)
  def build_xml_elements(data, base_module) do
    Map.keys(data)
    |> Enum.filter(fn key -> !Enum.member?(@ignored_keys, key) end)
    |> Enum.map(fn key ->
      build_xml_element(Map.get(data, key), key, base_module)
    end)
  end

  @doc """
  Builds one XML element for a given field value.
  """
  @spec build_xml_element(any, atom, module) :: tuple
  def build_xml_element(value, key, base_module) do
    element_value = ValueResolver.resolve(value, key, base_module)

    element_name =
      resolve_element_name(value, key)

    element(element_name, element_value)
  end

  defp resolve_element_name(value, key) do
    map_field_names = Application.get_env(:ecto_xml, :map_field_names)
    map_array_names = Application.get_env(:ecto_xml, :map_array_names)

    mapped_name =
      case value do
        _ when is_list(value) ->
          map_array_names
          |> Map.get(key)

        _ ->
          map_field_names
          |> Map.get(key)
      end

    mapped_name || key
  end
end
