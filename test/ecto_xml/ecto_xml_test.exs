# credo:disable-for-this-file Credo.Check.Readability.MaxLineLength

defmodule Test.EctoXml do
  @moduledoc false

  use ExUnit.Case, async: true

  doctest EctoXml

  defmodule Car do
    @moduledoc false

    use Ecto.Schema

    @primary_key false

    @derive {
      EctoXml.Builder,
      map_field_names: %{
        :brand => :car_brand,
        :colors => :color
      },
      map_array_names: %{
        :colors => :car_colors
      }
    }

    embedded_schema do
      field :price, :decimal

      embeds_one :brand, Brand
      embeds_many :colors, Color
    end
  end

  defmodule Brand do
    @moduledoc false

    use Ecto.Schema

    @primary_key false

    embedded_schema do
      field :name, :string
    end
  end

  defmodule Color do
    @moduledoc false

    use Ecto.Schema

    @primary_key false

    embedded_schema do
      field :name, :string
    end
  end

  describe "to_xml" do
    test "should correctly create a xml document with root name" do
      xml = %{foo: "bar"} |> EctoXml.to_xml(:root, format: :none)

      assert xml == "<?xml version=\"1.0\" encoding=\"UTF-8\"?><root><foo>bar</foo></root>"
    end
  end

  describe "to_partial_xml" do
    test "should correctly convert a map to partial xml" do
      xml = %{foo: "bar"} |> EctoXml.to_partial_xml(format: :none)

      assert xml == "<foo>bar</foo>"
    end
  end

  describe "ecto schemas" do
    test "should correctly create a xml document for the ecto schema" do
      car = %Car{
        price: Decimal.new(1000),
        brand: %Brand{name: "Audi"},
        colors: [
          %Color{name: "Black"},
          %Color{name: "White"},
          %Color{name: "Blue"},
          %Color{name: "Red"}
        ]
      }

      xml = EctoXml.to_xml(car, :car, format: :none)

      assert xml ==
               ~s(<?xml version=\"1.0\" encoding=\"UTF-8\"?><car><car_brand><name>Audi</name></car_brand><car_colors><color><name>Black</name></color><color><name>White</name></color><color><name>Blue</name></color><color><name>Red</name></color></car_colors><price>1000</price></car>)
    end
  end
end
