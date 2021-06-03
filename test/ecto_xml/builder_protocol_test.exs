# credo:disable-for-this-file Credo.Check.Readability.MaxLineLength

defmodule Test.BuilderProtocol do
  @moduledoc false

  use ExUnit.Case, async: true

  doctest EctoXml.Builder

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

  defmodule PersonWithParents do
    @moduledoc false

    use Ecto.Schema

    @primary_key false

    @derive {
      EctoXml.Builder,
      map_field_names: %{
        :parents => :custom_array_item_name
      },
      map_array_names: %{
        :parents => :custom_array_name
      }
    }

    embedded_schema do
      field :name, :string

      embeds_many :parents, Person
    end
  end

  describe "builder protocol" do
    test "should raise for not derived module" do
      assert_raise Protocol.UndefinedError, fn ->
        EctoXml.Builder.resolve_element_name(100, :foobar)
      end
    end

    test "should allow overriding field names (the list name and singular nested item names)" do
      xml =
        %Person{name: "John Doe"}
        |> EctoXml.to_xml(:person, format: :none)

      assert xml ==
               ~s(<?xml version=\"1.0\" encoding=\"UTF-8\"?><person><custom_element_name>John Doe</custom_element_name></person>)
    end

    test "should allow overriding array element names" do
      xml =
        %PersonWithParents{
          name: "John Doe",
          parents: [
            %Person{name: "Bob the builder"},
            %Person{name: "José Valim"}
          ]
        }
        |> EctoXml.to_xml(:person, format: :none)

      assert xml ==
               ~s(<?xml version=\"1.0\" encoding=\"UTF-8\"?><person><name>John Doe</name><custom_array_name><custom_array_item_name><name>Bob the builder</name></custom_array_item_name><custom_array_item_name><name>José Valim</name></custom_array_item_name></custom_array_name></person>)
    end
  end
end
