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
      case Kernel.function_exported?(base_module, :resolve_element_name, 2) do
        true -> apply(base_module, :resolve_element_name, [value, key])
        false -> key
      end

    element(element_name, element_value)
  end
end
