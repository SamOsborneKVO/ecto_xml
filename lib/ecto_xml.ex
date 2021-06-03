defmodule EctoXml do
  @moduledoc """
  Provides functions to generate XML documents based on Ecto Schemas and maps.

  It uses XmlBuilder under the hood, see: https://github.com/joshnuss/xml_builder.
  """

  import XmlBuilder

  alias EctoXml.BuildHelper

  @doc """
  Generates a XML document based on one ecto schema or map.

  The `document_name` argument refers to the XML root element name.

  ## Generating XML from maps

  The following:

  ```elixir
  %{foo: "bar"} |> EctoXml.to_xml(:root, format: :none)
  ```

  Results in:

  ```xml
  <?xml version=\"1.0\" encoding=\"UTF-8\"?><root><foo>bar</foo></root>
  ```

  ## Generating XML from an Ecto Schema

  For a given schema:

  ```elixir
  defmodule Person do
    @moduledoc false

    use Ecto.Schema

    @primary_key false

    embedded_schema do
      field :name, :string
    end
  end
  ```

  The following:

  ```elixir
  %Person{name: "Foo Bar"} |> EctoXml.to_xml(:person, format: :none)
  ```

  Results in:

  ```xml
  <?xml version=\"1.0\" encoding=\"UTF-8\"?><person><name>Foo Bar</name></person>
  ```

  ## Customizing field names

  For a given schema:

  ```elixir
  defmodule Person do
    @moduledoc false

    use Ecto.Schema

    @primary_key false

    @derive {
      EctoXml.Builder,
      map_field_names: %{
        :name => :custom_element_name
      }
    }

    embedded_schema do
      field :name, :string
    end
  end
  ```

  The following:

  ```elixir
  %Person{name: "Foo Bar"} |> EctoXml.to_xml(:person, format: :none)
  ```

  Results in:

  ```xml
  <?xml version=\"1.0\" encoding=\"UTF-8\"?><person><custom_element_name>Foo Bar</custom_element_name></person>
  ```
  """
  @spec to_xml(map, atom, list) :: String.t()
  def to_xml(data, document_name, options \\ []) do
    elements = generate_xml_elements(data)

    document(document_name, elements)
    |> XmlBuilder.generate(options)
  end

  @doc """
  Generates a partial XML element based on one ecto schema or map.

  The behaviour is idential to to_xml/3, except that it does not generate the XML document (e.g. <?xml version=X encoding=Y?>)
  with a root element name (e.g. <root> content </root>), generating only the partial element instead.

  ## Example

  The following:

  ```elixir
  %{foo: "bar"} |> EctoXml.to_partial_xml()
  ```

  Results in:

  ```xml
  <foo>bar</foo>
  ```

  Check to_xml/3 for more examples and use cases.
  """
  @spec to_partial_xml(map, list) :: String.t()
  def to_partial_xml(data, options \\ []) do
    generate_xml_elements(data)
    |> XmlBuilder.generate(options)
  end

  @spec generate_xml_elements(map) :: list
  defp generate_xml_elements(data) do
    base_module = Map.get(data, :__struct__)

    BuildHelper.build_xml_elements(data, base_module)
  end
end
