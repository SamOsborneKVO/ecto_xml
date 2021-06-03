defmodule Test.FieldTypes do
  @moduledoc false

  use ExUnit.Case, async: true

  doctest EctoXml

  describe "field types" do
    test "should convert: String" do
      xml = %{foo: "Consequat commodo duis nulla."} |> EctoXml.to_partial_xml(format: :none)

      assert xml == "<foo>Consequat commodo duis nulla.</foo>"
    end

    test "should convert: Integer" do
      xml = %{foo: 42} |> EctoXml.to_partial_xml(format: :none)

      assert xml == "<foo>42</foo>"
    end

    test "should convert: Decimal" do
      xml = %{foo: Decimal.new(42)} |> EctoXml.to_partial_xml(format: :none)

      assert xml == "<foo>42</foo>"
    end

    test "should convert: NaiveDateTime (using ISO8601)" do
      xml = %{foo: ~N[2021-03-31 00:00:00]} |> EctoXml.to_partial_xml(format: :none)

      assert xml == "<foo>2021-03-31 00:00:00</foo>"
    end

    test "should convert: DateTime (using ISO8601)" do
      xml = %{foo: ~U[2015-01-23 23:50:07Z]} |> EctoXml.to_partial_xml(format: :none)

      assert xml == "<foo>2015-01-23 23:50:07Z</foo>"
    end

    test "should convert: Date" do
      xml = %{foo: ~D[2000-01-01]} |> EctoXml.to_partial_xml(format: :none)

      assert xml == "<foo>2000-01-01</foo>"
    end

    test "should convert: List" do
      xml = %{foo: [10, 20, 30]} |> EctoXml.to_partial_xml(format: :none)

      assert xml == "<foo><foo>10</foo><foo>20</foo><foo>30</foo></foo>"
    end

    test "should convert: Nested Maps" do
      xml = %{foo: %{bar: %{baz: "jazz"}}} |> EctoXml.to_partial_xml(format: :none)

      assert xml == "<foo><bar><baz>jazz</baz></bar></foo>"
    end
  end
end
