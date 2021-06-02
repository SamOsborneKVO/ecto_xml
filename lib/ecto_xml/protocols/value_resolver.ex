defprotocol EctoXml.ValueResolver do
  @moduledoc """
  Protocol to resolve XML element values.
  """

  @fallback_to_any true

  @spec resolve(t, atom, module) :: any
  def resolve(value, key, base_module)
end

defimpl EctoXml.ValueResolver, for: Any do
  def resolve(value, _key, base_module) do
    case value do
      _ when is_struct(value) -> EctoXml.BuildHelper.build_xml_elements(value, base_module)
      _ when is_map(value) -> EctoXml.BuildHelper.build_xml_elements(value, base_module)
      _ -> value
    end
  end
end

defimpl EctoXml.ValueResolver, for: List do
  def resolve(value, key, base_module) do
    Enum.map(value, fn item -> EctoXml.BuildHelper.build_xml_element(item, key, base_module) end)
  end
end

defimpl EctoXml.ValueResolver, for: Decimal do
  def resolve(value, _key, _base_module) do
    Decimal.to_string(value)
  end
end

defimpl EctoXml.ValueResolver, for: Date do
  def resolve(value, _key, _base_module) do
    Date.to_string(value)
  end
end

defimpl EctoXml.ValueResolver, for: DateTime do
  def resolve(value, _key, _base_module) do
    DateTime.to_string(value)
  end
end

defimpl EctoXml.ValueResolver, for: NaiveDateTime do
  def resolve(value, _key, _base_module) do
    NaiveDateTime.to_string(value)
  end
end
